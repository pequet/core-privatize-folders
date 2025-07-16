---
type: overview
domain: system-state
subject: Core Privatize Folders
status: active
summary: The problem, proposed solution, and user experience goals.
---
# Product Context

## 1. Problem Statement

*   **Problem being solved for target audience?** *(Be specific)*

    *   When developers set up a new project from a public boilerplate, they must manually separate private, context-specific folders (e.g., `.cursor`, `.specstory`, `memory-bank`, `inbox`) from the public repository. This manual process is tedious, repetitive, and highly prone to error, such as incorrect symlink creation or forgetting to update `.gitignore`, which can lead to accidental commits of sensitive information.

*   **Importance/benefits of solving it?**

    *   Automating this process dramatically improves developer efficiency and reduces setup time. It ensures a consistent, reliable, and secure separation of public and private assets across all projects, eliminating a common source of errors and enforcing a critical architectural pattern within the development framework.

## 2. Proposed Solution

*   **How will this project solve the problem(s)?** *(Core concept)*

    *   This project provides a dedicated, reusable Bash script named `privatize-folders.sh`. The script is designed to be run as the final step in a new project setup workflow. It reads a configuration file listing folders to be privatized, moves them to an adjacent private directory, creates relative symlinks, and updates `.gitignore` automatically.

*   **Key features delivering the solution?**

    *   **Configurable Folder List:** A simple `default.config` text file defines which folders to privatize, and this can be overridden with a custom file, making the script adaptable.
    *   **Automated File Operations:** Moves existing folders or creates them if they don't exist in the target private location.
    *   **Relative Symlink Creation:** Ensures the project structure remains portable.
    *   **Intelligent `.gitignore` Management:** Checks for and updates `.gitignore` to exclude the new symlinks, preventing accidental commits.
    *   **CLI-Driven:** Operates non-interactively via command-line arguments for source and target paths.
    *   **Consistent Tooling:** Mirrors the logging, locking, and output style of its sibling script, `apply-boilerplate.sh`.

## 3. How It Should Work (User Experience Goals)

*   **Ideal user experience?** *(What should it feel like?)*

    *   The experience should be simple, fast, and reliable. The developer runs a single command and can trust that the folder privatization is handled correctly without any need for manual verification or cleanup. It should feel like a seamless, "fire-and-forget" part of the setup process.

*   **Non-negotiable UX principles?**

    *   **Reliability:** The script must work flawlessly every time. Its operations must be atomic and correct.
    *   **Clarity:** Terminal output must be informative, clearly stating what actions were taken and confirming success.
    *   **Flexibility:** The script must be easily adaptable to different boilerplates and project needs through its configuration file.

## 4. Unique Selling Proposition (USP)

*   **What makes this different or better than existing solutions?**

    *   This is not a generic script but a purpose-built utility designed as a key component of a larger, opinionated development workflow. Its tight integration and shared conventions with the `apply-boilerplate.sh` script make it a natural and efficient tool for its specific context, rather than a solution that needs to be adapted.

*   **Core value proposition for the user?**

    *   It provides a fully automated, reliable solution for the critical "last-mile" setup task of separating public and private code, enforcing security and architectural best practices with zero manual effort.

## 5. Assumptions About Users

*   **Assumptions about users' tech skills, motivations, technology access?**

    *   Users are developers working in a Unix-like environment (macOS, Linux).
    *   Users are comfortable with the command line.
    *   Users are following the established framework workflow where this script is the third step (Submodule -> Apply Boilerplate -> Privatize Folders).
    *   The project directory structure consists of a public Git repository located adjacent to a private directory (e.g., `.../public-repo/` and `.../private/`).

## 6. Success Metrics (Product-Focused)

*   **How to measure product's success in solving user problems?** *(User-centric KPIs)*

    *   **Adoption Rate:** The script is consistently used as the standard procedure for all new project setups.
    *   **Reliability:** A near-zero rate of manual corrections or interventions required after the script is run.
    *   **Efficiency:** A measurable reduction in the time and cognitive load required for new project initialization.

---
**How to Use This File Effectively:**
This document defines *why* the product is being built and *what* it aims to achieve for the user. Update it when the understanding of the user problem, proposed solution, or core value proposition evolves. It provides crucial context for feature development and design decisions.
