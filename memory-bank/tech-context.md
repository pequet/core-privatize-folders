---
type: overview
domain: system-state
subject: Core Privatize Folders
status: active
summary: Technologies, setup, and technical constraints of the project.
---
# Technical Context

## 1. Technologies Used
List significant technologies, frameworks, libraries, tools.

*   **Language:**
    *   Bash
*   **Core Tools:**
    *   Standard Unix/Linux command-line utilities (`mv`, `ln`, `mkdir`, `sed`, `grep`, `find`, etc.).
*   **Version Control:**
    *   Git

## 2. Development Setup & Environment
How to set up the dev environment.

*   **Prerequisites:**
    *   A Unix-like command-line environment (e.g., macOS, Linux, or WSL on Windows).
    *   Standard core utilities must be installed and available in the system's `PATH`.
    *   Git for version control.
*   **Setup Steps:**
    1.  Clone the `core-privatize-folders` repository from GitHub.
    2.  No package installation or dependency management is required.
    3.  Ensure the main script is executable (`chmod +x scripts/privatize-folders.sh`).

## 3. Technical Constraints
List known technical limitations.

*   **Platform Dependency:** The script is fundamentally dependent on a `bash` shell and standard Unix utilities. It will not run in native Windows environments like CMD or PowerShell.
*   **File System Requirements:** The script assumes the underlying file system supports symbolic links, which may be a constraint on some older or non-standard file systems.
*   **Tool Behavior Variance:** The behavior of core utilities can differ between platforms (e.g., the `-i` flag for `sed` on macOS/BSD vs. GNU/Linux). The script must account for these differences to ensure portability.

## 4. Dependencies & Integrations (Technical Details)
Key technical details for dependencies/integrations.

*   **Dependency 1:** `bash`
    *   The script requires a reasonably modern version of the Bash shell to run.
*   **Dependency 2:** Core Unix Utilities
    *   The script relies on the presence and standard behavior of `mv`, `ln`, `mkdir`, `grep`, `sed`, `find`.
*   **Integration 1:** File System
    *   The script's primary function is to directly manipulate the file system by moving directories and creating symbolic links.
*   **Integration 2:** Git
    *   The script integrates with the Git version control system by reading from and writing to the `.gitignore` file.

## 5. Code & Branching Strategy
Describe the version control system, branching model, and code review process.

*   **VCS:** Git
*   **Hosting:** GitHub
*   **Branching Model:** Standard GitHub Flow (create feature branches from `main`, open pull requests to merge back into `main`).
*   **Code Review:** All changes should be submitted via pull requests for review.
*   **Commit Messages:** Adherence to the Conventional Commits standard is encouraged for clear and automated changelog generation.

## 6. Build & Deployment Process
Describe the build process, deployment pipeline, and hosting environment.

*   **Build Process:** N/A. As a shell script, there is no build or compilation step.
*   **Deployment Process:** This is a utility repository, not a deployed service. "Deployment" consists of cloning the repository to a local machine where the script can be executed against other local project directories.

---
**How to Use This File Effectively:**
This document details the technical landscape of your project. Use it to understand the tools, setup procedures, constraints, and deployment workflows. Keep it updated as new technologies are adopted, setup steps change, or the deployment process evolves. It's essential for developer onboarding and maintaining a shared understanding of the tech stack.
