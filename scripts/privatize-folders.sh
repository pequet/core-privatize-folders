#!/bin/bash

# Standard Error Handling
set -euo pipefail

# █████  Core Privatize Folders: Generalized Boilerplate Application Utility
# █  ██  Version: 1.0.0
# █ ███  Author: Benjamin Pequet
# █████  GitHub: https://github.com/pequet/core-privatize-folders
#
# Purpose:
#   Automates the privatization of specified folders for a new project.
#   It moves target folders from a public repository to an adjacent private
#   directory, creates relative symlinks, and updates the .gitignore file.
#   This ensures a clean separation between public and private assets.
#
# Usage:
#   ./privatize-folders.sh -s <path> -p <path> [-c <config_name>]
#
# Options:
#   -s, --source <path>     (Required) Path to the source public repository.
#   -p, --private <path>    (Required) Path to the target private directory.
#   -c, --config <name>     (Optional) Name of a config file (e.g., 'cursor_project'
#                           for 'cursor_project.config'). Defaults to 'default.config'.
#
# Dependencies:
#   - Standard Unix utilities: ln, mv, mkdir, grep, sed
#
# Changelog:
#   1.0.0 - 2024-07-16 - Initial release.
#
# Support the Project:
#   - Buy Me a Coffee: https://buymeacoffee.com/pequet
#   - GitHub Sponsors: https://github.com/sponsors/pequet

# --- Global Variables ---
# Resolve the true script directory, following symlinks
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
SCRIPT_DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"

LOG_DIR="${SCRIPT_DIR}/../logs"
LOG_FILE_PATH="${LOG_DIR}/privatize_folders.log"
LOCK_DIR="/tmp"
LOCK_FILE_PATH="${LOCK_DIR}/core_privatize_folders.lock"

# Source shared utilities
source "${SCRIPT_DIR}/utils/logging_utils.sh"
source "${SCRIPT_DIR}/utils/messaging_utils.sh"

# --- Function Definitions ---

# *
# * Script Usage
# *
usage() {
  echo "Usage: $0 -s|--source <path> -p|--private <path> [-c|--config <name>]"
  echo
  echo "Automates the privatization of folders by moving them and creating symlinks."
  echo
  echo "Options:"
  echo "  -s, --source <path>     Required. Path to the source public repository."
  echo "  -p, --private <path>    Required. Path to the target private directory."
  echo "  -c, --config <name>     Optional. Config name. Defaults to 'default.config'."
  exit 1
}

# *
# * Cleanup
# *
cleanup() {
    if [ -f "${LOCK_FILE_PATH}" ]; then
        rm -f "${LOCK_FILE_PATH}"
        log_message "INFO" "Lock file removed."
    fi
}

# *
# * Gitignore Management
# *
update_gitignore() {
    local source_repo_path="$1"
    shift
    local folders_to_ignore=("$@")
    local gitignore_path="${source_repo_path}/.gitignore"
    local header="# Privatized Folders [core-privatize-folders script]"
    local footer="# --------------------------------------------------"
    local temp_gitignore
    local modified=false

    temp_gitignore=$(mktemp)

    if [ ! -f "$gitignore_path" ]; then
        touch "$gitignore_path"
    fi

    # Process each line, looking for commented entries to uncomment
    while IFS= read -r line || [[ -n "$line" ]]; do
        local line_modified=false
        
        # Check if this line is our old managed block header/footer - skip it
        if [[ "$line" == "$header" ]] || [[ "$line" == "$footer" ]]; then
            continue
        fi
        
        # For each folder we need to ignore, check if this line is a commented version
        for folder in "${folders_to_ignore[@]}"; do
            # Look for patterns like "# **/folder" or "# folder" or "# folder/"
            if [[ "$line" =~ ^[[:space:]]*#[[:space:]]*(\*\*/)?${folder}(/|\*\*)?[[:space:]]*$ ]]; then
                # Uncomment it and add our marker
                local uncommented_line
                uncommented_line=$(echo "$line" | sed 's/^[[:space:]]*#[[:space:]]*//')
                echo "${uncommented_line}  # Uncommented by [core-privatize-folders]" >> "$temp_gitignore"
                line_modified=true
                modified=true
                break
            fi
        done
        
        # If we didn't modify this line, keep it as-is
        if [ "$line_modified" = false ]; then
            echo "$line" >> "$temp_gitignore"
        fi
    done < "$gitignore_path"

    # Now check which folders still need to be added (weren't found commented)
    local folders_to_add=()
    for folder in "${folders_to_ignore[@]}"; do
        # Check if the folder is already actively ignored (not commented)
        if grep -qE "^[[:space:]]*(\*\*/)?${folder}(/|\*\*)?[[:space:]]*(\#.*)?$" "$temp_gitignore"; then
            # Already handled (either was uncommented above or was already active)
            continue
        else
            # Not found at all, need to add it
            folders_to_add+=("$folder")
        fi
    done

    # Add any folders that weren't found anywhere in the .gitignore
    if [ ${#folders_to_add[@]} -gt 0 ]; then
        modified=true
        
        # Ensure there's a newline before our block if the file isn't empty
        if [ -s "$temp_gitignore" ]; then
            if [ "$(tail -c1 "$temp_gitignore" | wc -l)" -eq 0 ]; then
                echo "" >> "$temp_gitignore"
            fi
        fi

        echo "$header" >> "$temp_gitignore"
        for folder in "${folders_to_add[@]}"; do
            echo "**/${folder}" >> "$temp_gitignore"
            echo "**/${folder}/" >> "$temp_gitignore"
        done
        echo "$footer" >> "$temp_gitignore"
    fi

    # Only update the file if we actually made changes
    if [ "$modified" = true ]; then
        mv "$temp_gitignore" "$gitignore_path"
        print_status_line "[GITIGNORE]" "Updated successfully" "SUCCESS"
    else
        rm -f "$temp_gitignore"
        print_status_line "[GITIGNORE]" "No changes needed" "INFO"
    fi
}

# --- Script Entrypoint ---
main() {
    # Ensure logs and locks directories exist
    ensure_log_directory
    mkdir -p "${LOCK_DIR}"

    local SOURCE_PATH=""
    local PRIVATE_PATH=""
    local CONFIG_NAME="default"

    # Parameter Parsing
    while [[ "$#" -gt 0 ]]; do
        case $1 in
            -s|--source) SOURCE_PATH="$2"; shift ;;
            -p|--private) PRIVATE_PATH="$2"; shift ;;
            -c|--config) CONFIG_NAME="$2"; shift ;;
            *) print_error "Unknown parameter passed: $1"; usage ;;
        esac
        shift
    done

    # Validation
    if [ -z "$SOURCE_PATH" ] || [ -z "$PRIVATE_PATH" ]; then
        print_error "Missing required --source or --private parameters."
        usage
    fi

    if [ ! -d "$SOURCE_PATH" ] || [ ! -d "$PRIVATE_PATH" ]; then
        print_error "Source or Private path is not a valid directory."
        usage
    fi
    
    SOURCE_PATH="$(cd "$SOURCE_PATH" && pwd)"
    PRIVATE_PATH="$(cd "$PRIVATE_PATH" && pwd)"
    local config_file_path="${SCRIPT_DIR}/${CONFIG_NAME}.config"

    if [ ! -f "$config_file_path" ]; then
        print_error "Configuration file not found at '$config_file_path'."
        exit 1
    fi
    
    # --- Locking ---
    if [ -e "${LOCK_FILE_PATH}" ]; then
        print_error "Lock file exists at ${LOCK_FILE_PATH}. Another instance may be running."
        exit 1
    fi
    touch "${LOCK_FILE_PATH}"
    trap cleanup EXIT # Register cleanup function to run on script exit

    print_header "Core Privatize Folders"
    print_info "Source Public Repo: $SOURCE_PATH"
    print_info "Target Private Dir: $PRIVATE_PATH"
    print_info "Using config:       $config_file_path"
    print_separator

    local folders_to_privatize=()
    while IFS= read -r line || [[ -n "$line" ]]; do
        # Ignore comments and empty lines
        line_trimmed=$(echo "$line" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
        [[ "$line_trimmed" =~ ^\s*# ]] || [[ -z "$line_trimmed" ]] && continue
        folders_to_privatize+=("$line_trimmed")
    done < "$config_file_path"

    if [ ${#folders_to_privatize[@]} -eq 0 ]; then
        print_warning "No folders listed in the configuration file. Nothing to do."
        exit 0
    fi

    print_step "Processing and symlinking folders"
    local private_dir_name
    private_dir_name=$(basename "$PRIVATE_PATH")

    for folder in "${folders_to_privatize[@]}"; do
        local source_folder_path="${SOURCE_PATH}/${folder}"
        local private_folder_path="${PRIVATE_PATH}/${folder}"
        local relative_path_to_private="../${private_dir_name}/${folder}"
        
        # 1. Move or Create
        if [ -d "$source_folder_path" ]; then
            if ! mv "$source_folder_path" "$PRIVATE_PATH/"; then
                print_error "Failed to move '$source_folder_path' to '$PRIVATE_PATH/'."
                exit 1
            fi
            print_status_line "[MOVING]" "$folder -> $relative_path_to_private" "SUCCESS"
        else
            if ! mkdir -p "$private_folder_path"; then
                 print_error "Failed to create directory '$private_folder_path'."
                 exit 1
            fi
            print_status_line "[CREATING]" "$folder -> $relative_path_to_private" "SUCCESS"
        fi

        # We've observed that file system checks are unreliable with some sync
        # services (like iCloud Drive). A folder can appear "moved" to the script,
        # while a remnant is still left at the source, causing `ln` to fail or
        # create an incorrect link (e.g., 'folder 2').
        # Smart verification loops were tried and failed to solve this.
        # As a last resort, we are using a hard-coded sleep to give the OS
        # time to reliably sync the file system state.
        sleep 2

        # 2. Create Relative Symlink
        # We must be inside the source directory to create a *relative* link.
        (
            cd "$SOURCE_PATH"
            # We are not checking for remnants or `ln` command failure here.
            # The `sleep 2` above is a pragmatic attempt to avoid race conditions
            # with file syncing services like iCloud Drive. If a symlink is
            # created with a numbered suffix (e.g., "folder 2"), it indicates
            # the sleep duration was insufficient for the sync to complete.
            # `set -e` will still cause the script to exit on a true command error.
            ln -s "$relative_path_to_private" "$folder"
            print_status_line "[SYMLINKING]" "$folder -> $relative_path_to_private" "SUCCESS"
        )
    done

    print_step "Updating .gitignore"
    update_gitignore "$SOURCE_PATH" "${folders_to_privatize[@]}"

    print_separator
    print_completed "Folders privatized successfully."
    print_footer
}

main "$@" 