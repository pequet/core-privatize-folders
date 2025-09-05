---
type: overview
domain: system-state
subject: Privatize Folders
status: active
summary: High-level architecture, key design decisions, and system-wide patterns.
---
# System Patterns

## 1. System Architecture Overview

*   **Overall architecture & justification?** *(e.g., Monolithic, Microservices, Client-Server)*

    *   This project's architecture is that of a single, standalone **procedural utility script** (`privatize-folders.sh`). It is designed as a modular, single-purpose tool that executes a linear sequence of file system operations. Its purpose is to be a component in a larger, external development workflow, rather than being a complex system in itself.

*   **High-Level Diagram Link (Recommended):**

    *   N/A. A diagram is not necessary for a single-script utility.

## 2. Key Architectural Decisions & Rationales
List significant decisions and why they were made.

*   **Decision 1:** Develop as a standalone script, separate from `apply-boilerplate.sh`.
    *   **Rationale:** This enforces a clear separation of concerns. `apply-boilerplate.sh` is for content copying and token replacement, while `privatize-folders.sh` is for structuring public/private assets. This makes each tool simpler, more focused, and easier to maintain.
*   **Decision 2:** Use an external configuration file to list the folders.
    *   **Rationale:** This decouples the script's logic from the specific folder names of any given project. It makes the script highly reusable and adaptable for different boilerplates without requiring any code modifications.
*   **Decision 3:** Automate the management of the `.gitignore` file.
    *   **Rationale:** This is a critical, error-prone step. Automating it removes the burden from the developer, prevents accidental commits of symlinks, and ensures repository cleanliness and security.
*   **Decision 4:** Create relative symbolic links.
    *   **Rationale:** Relative paths ensure that the paired public and private project directories can be moved together to different locations on a file system without breaking the links between them, enhancing portability.

## 3. Design Patterns in Use
List key software design patterns and where they are used.

*   **Pattern 1: Template Method (Conceptual)**
    *   The script follows a fixed, unchangeable sequence of operations (Validate Inputs -> Read Config -> Process Folders -> Create Symlinks -> Update Gitignore). The variable part of the algorithm is the list of folders provided by the configuration file.
*   **Pattern 2: Configuration File**
    *   A classic pattern used here to separate the script's unchanging logic from the data (folder list) that it operates on, which can vary between projects.
*   **Pattern 3: Idempotency**
    *   The `.gitignore` update logic is designed to be idempotent. The script can be run multiple times without creating duplicate entries, ensuring a safe and predictable outcome.

## 4. Component Relationships & Interactions
Describe how major components interact.

*   The `privatize-folders.sh` script is the sole component. It interacts with:
    *   **The User:** via command-line arguments (`-s`, `-p`, `-c`) for input and standard output/error for feedback.
    *   **The File System:** by reading the configuration file, moving directories, creating symlinks, and reading/writing to the `.gitignore` file.
    *   **Git (Indirectly):** by modifying the `.gitignore` file, which directly influences Git's behavior for all subsequent operations in the repository.

## 5. Data Management & Storage

*   **Primary Datastore & Rationale:**

    *   The local file system is the only datastore. The script reads a plain text configuration file and modifies the directory structure. This is appropriate for a simple, self-contained utility script.

*   **Data Schema Overview/Link:**

    *   The data schema is that of the configuration file (e.g., `default.config`): a newline-separated list of folder names. Lines beginning with `#` are ignored as comments.

*   **Data Caching Strategies:**

    *   N/A.

*   **Data Backup/Recovery Plan:**

    *   N/A. Users should rely on their own version control (Git) for backup and recovery of the public repository. The script does not perform destructive operations without user action.

## 6. Integration Points with External Systems
List external services/systems integrations.

*   **System 1:** The local operating system's shell environment (`bash`) and core utilities (`mv`, `ln`, `mkdir`, `grep`, `sed`, etc.).
*   **System 2:** The Git version control system. The script's primary purpose is to prepare a directory for proper use with Git by managing which assets are tracked (public) versus ignored (private via symlinks).

---
**How to Use This File Effectively:**
This document outlines the technical blueprint of the system. Refer to it for understanding architectural choices, design patterns, and how components interact. Update it when significant architectural decisions are made, new patterns are introduced, or data management strategies change. It is crucial for onboarding new developers and ensuring consistent technical approaches.
