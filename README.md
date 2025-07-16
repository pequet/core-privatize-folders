# Core Privatize Folders

This repository contains the `privatize-folders.sh` script, a utility designed to automate the separation of public and private assets within a project structure. It works by moving specified folders to an adjacent private directory, creating relative symbolic links in their original locations, and ensuring the new symlinks are correctly ignored by Git.

This script is a key component in the project setup workflow and is a companion utility to `apply-boilerplate.sh`.

## The "Private Context" Philosophy

Modern development often involves context-heavy directories for AI assistants, project history, and personal notes (e.g., `.cursor`, `memory-bank`, `inbox`). While essential for development, this information is private and should not be committed to a public repository.

Simply adding these folders to `.gitignore` is insufficient, as it prevents their contents from being version-controlled anywhere.

The `privatize-folders.sh` script solves this by implementing the **"Private Context"** pattern:
1.  **Isolate**: It moves private folders out of your public repository (the "source").
2.  **Preserve**: It places them into an adjacent, private Git repository (the "private").
3.  **Link**: It leaves behind symlinks in the public repo, so your tools continue to work seamlessly.
4.  **Ignore**: It updates the public repo's `.gitignore` to ignore these new symlinks.

This allows to safely manage public-facing boilerplates or open-source projects without exposing development history, while still tracking all private context in the core repository.

## Usage

The script is executed from the command line with parameters specifying the source (public) and target (private) directories.

### Command-Line Options

*   `-s, --source <path>`: **(Required)** The path to the public repository where the folders currently reside (e.g., your Git submodule).
*   `-p, --private <path>`: **(Required)** The path to the adjacent directory where folders should be moved (e.g., the root of your private repository).
*   `-c, --config <name>`: **(Optional)** The name of a specific configuration to use (e.g., `cursor_project`). If this flag is used, the script will look for `<name>.config`. If omitted, it defaults to `default.config`.

### Example

```bash
./scripts/privatize-folders.sh -s ./my-project/submodule -p ./my-project
```
or if installed globally:
```bash
core-privatize-folders.sh -s ./my-project/submodule -p ./my-project
```

## Configuration

The list of folders to be privatized is defined in a simple text file. By default, the script looks for `default.config` in its own directory (`scripts/`).

**Example `default.config`:**
```
# Folders to privatize
.cursor
.specstory
inbox
archives
memory-bank
```

## Installation

An installer script is provided to make the command globally available on your system.

1.  Open your Terminal.
2.  Navigate to the directory where you cloned this repository.
3.  Run the installer:

```bash
./install.sh
```

The script will ask for your administrator password to create a symbolic link in `/usr/local/bin`.

**Benefit of Installation:** Once installed, the script integrates with your command line. You can type `core-` and press the `Tab` key to see and auto-complete `core-privatize-folders.sh`, along with any other `core-` scripts you have installed. (Note: You may need to open a new terminal or run `rehash` for the command to become available in your current session).

## License

This project is licensed under the MIT License.

## Support the Project

If you find this project useful and would like to show your appreciation, you can:

- [Buy Me a Coffee](https://buymeacoffee.com/pequet)
- [Sponsor on GitHub](https://github.com/sponsors/pequet)

Your support helps in maintaining and improving this project. Thank you!

