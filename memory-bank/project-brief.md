---
type: overview
domain: system-state
subject: Core Privatize Folders
status: active
summary: Core project goals, requirements, and scope.
---
# Project Brief

## 1. Project Goal

*   **Primary Objective:** The primary objective is to create a robust, reusable, and automated script (`privatize-folders.sh`) that completely handles the separation of public and private folders during the setup of a new project.

*   **Secondary Objectives (Optional):**
    *   Ensure the script is flexible enough to handle different project boilerplates through an external configuration file.
    *   Provide clear, actionable feedback to the user via terminal output.
    *   Align the script's design, features (logging, locking), and user experience with its sibling utility, `apply-boilerplate.sh`, to ensure a consistent toolchain.

## 2. Core Requirements & Functionality
What must the project do at a minimum? List the essential features and functionalities.

*   **Requirement 1:** Accept source (public) and target (private) directory paths as command-line arguments.
*   **Requirement 2:** Read a list of folder names to be privatized from a specified (`<name>.config`) or default (`default.config`) configuration file.
*   **Requirement 3:** For each folder in the list, move it from the source to the target directory. If it doesn't exist in the source, create it in the target.
*   **Requirement 4:** Create a relative symbolic link in the source directory pointing to the folder's new location in the target directory.
*   **Requirement 5:** Intelligently update the `.gitignore` file in the source directory to ensure the new symlinks are ignored.

## 3. Target Audience
Who is this project for? Describe the primary users.

*   The target audience is developers using the parent development framework. Specifically, any developer who is initializing a new project from a boilerplate and needs to follow the standard procedure of separating sensitive or context-specific folders from a public-facing Git repository.

## 4. Scope (Inclusions & Exclusions)

### In Scope:
What features and tasks are definitely part of this project?

*   The `privatize-folders.sh` script itself.
*   All associated utility functions for logging, messaging, and file operations.
*   The mechanism for reading the folder list from a configuration file.
*   All documentation within this repository (`README.md`, `memory-bank/`).

### Out of Scope:
What features and tasks are explicitly NOT part of this project (at least for the initial version)?

*   The `apply-boilerplate.sh` script (it is a reference, but will not be modified).
*   A graphical user interface (GUI). This is a command-line-only tool.
*   Native support for non-Unix-like environments (e.g., Windows CMD/PowerShell).
*   The initial creation of the parent public/private directory structure; the script assumes these directories already exist.

## 5. Success Criteria & Key Performance Indicators (KPIs)
How will you know if the project is successful? What metrics will you track?

*   **Criteria:**
    *   **Reliability:** The script runs without errors and consistently achieves the correct final state (folders moved, symlinks created, `.gitignore` updated).
    *   **Usability:** The script is simple to execute with clear, understandable parameters.
    *   **Maintainability:** The script's code is clean, well-commented, and easy to modify or extend.
*   **KPIs:**
    *   **Manual Effort Reduction:** The time required for the folder privatization step of a new project setup is reduced to the time it takes to run a single command.
    *   **Error Rate:** A measurable decrease (ideally to zero) in setup errors related to manual symlinking or incorrect `.gitignore` entries.
    *   **Adoption:** The script becomes the standard, required method for this task within the development workflow.

## 6. Assumptions
List any assumptions being made that could impact the project.

*   A Unix-like environment (macOS, Linux) with standard tools (`bash`, `ln`, `mv`, `mkdir`) is available.
*   The user provides valid, existing paths for the source (public) and target (private) directories.
*   The target private directory is located adjacent to the source public directory, allowing for simple relative symlinks (e.g., `../private/`).

## 7. Constraints & Risks
Identify any limitations or potential problems.

*   **Constraint:** As a Bash script, it is not inherently cross-platform. It will not run on Windows without a compatibility layer like WSL.
*   **Risk:** Differences in tool behavior across platforms (e.g., `sed` on macOS vs. Linux) could cause compatibility issues. (Mitigation: Add platform-specific checks for such commands, as seen in the reference script).
*   **Risk:** User error in providing CLI arguments (e.g., incorrect paths) could lead to unintended file system operations. (Mitigation: Implement robust input validation and clear error messaging at the start of the script).

## 8. Stakeholders
Who are the key people involved or affected by this project?

*   **Project Sponsor/Owner:** Benjamin Pequet
*   **Primary Users:** Developers within the framework ecosystem.

