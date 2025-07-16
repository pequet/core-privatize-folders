# Core Privatize Folders

This repository contains the `privatize-folders.sh` script, a utility designed to automate the separation of public and private assets within a project structure. It works by moving specified folders to an adjacent private directory, creating relative symbolic links in their original locations, and ensuring the new symlinks are correctly ignored by Git.

## Reasoning

When setting up new projects, especially from public boilerplates, developers often need to keep certain directories private (e.g., `.cursor`, `memory-bank`, `inbox`). Manually moving these folders, creating symlinks, and updating `.gitignore` is a repetitive and error-prone process. This script automates that workflow, ensuring consistency and saving developer time.

It is designed as a sibling utility to `apply-boilerplate.sh` and is intended to be run immediately after a new project submodule has been initialized with a boilerplate.

## Context

The `privatize-folders.sh` script is the third step in a standardized project setup workflow:
1.  A new public Git submodule is created.
2.  A project template is applied to it using `apply-boilerplate.sh`.
3.  `privatize-folders.sh` is run to move sensitive or context-specific directories out of the public submodule and into a parallel private location.

For more details on this workflow, refer to the internal guide `How to Correctly Add a Git Submodule.md`.

## How the Script Works

The script is non-interactive and driven by command-line arguments and a configuration file.

### Core Workflow

1.  **Read Configuration**: It reads a list of folder names from a configuration file (e.g., `privatize.config`).
2.  **Process Folders**: For each folder in the list:
    *   If the folder exists in the source (public) repo, it is **moved** to the target (private) directory.
    *   If the folder does not exist, an empty directory with that name is **created** in the target (private) directory.
3.  **Create Symlinks**: It creates a relative symbolic link in the source repository pointing to the new location of each folder in the private directory.
4.  **Update `.gitignore`**: It intelligently updates the `.gitignore` file in the source repository to ensure the newly created symlinks are ignored, preventing them from being committed to the public repository.

### Configuration File

The list of folders to be privatized is defined in a simple text file. By default, the script looks for `privatize.config`, but a custom name can be specified.

**Example `privatize.config`:**
```
# Folders to privatize
.cursor
.specstory
inbox
archives
memory-bank
```

## Script Usage

The script is executed from the command line with parameters specifying the source (public) and target (private) directories.

### Basic Usage

```bash
./scripts/privatize-folders.sh -s <path_to_public_repo> -p <path_to_private_dir>
```

### Advanced Usage

Specify a custom configuration file name:

```bash
./scripts/privatize-folders.sh -s <path_to_public_repo> -p <path_to_private_dir> -c <config_name>
```

### Command-Line Options

*   `-s, --source <path>`: **(Required)** The path to the public repository where the folders currently reside.
*   `-p, --private <path>`: **(Required)** The path to the adjacent directory where folders should be moved.
*   `-c, --config <name>`: **(Optional)** The name of a specific configuration file to use (e.g., `project-template.config`). If omitted, it defaults to `privatize.config`.

## Advanced Usage: Private Context

This script is the implementation of the "Private Context" concept. By moving context-heavy directories like `.cursor` and `memory-bank` to a private location and replacing them with symlinks, you can maintain a clean separation between your public, shareable code and your private, session-specific development environment.

This allows you to safely manage public-facing boilerplates or open-source projects without exposing your development history, AI conversations, or other sensitive information.

## License

This project is licensed under the MIT License.

## Support the Project

If you find this project useful and would like to show your appreciation, you can:

- [Buy Me a Coffee](https://buymeacoffee.com/pequet)
- [Sponsor on GitHub](https://github.com/sponsors/pequet)

Your support helps in maintaining and improving this project. Thank you! 

