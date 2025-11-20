# GEMINI.md

## Project Overview

[Brief description of the project]

## 🧠 Knowledge Management (AI Instructions)

This project uses a **Session-centric** documentation system. As an AI, you MUST follow these rules:

### 1. Before Starting a Task
- **Check Context**: Read `docs/INDEX-product.md` and `docs/INDEX-architecture.md` to understand the current state.
- **Check History**: If modifying an existing feature, find the related session in `docs/sessions/` to understand previous decisions.

### 2. During Development
- **Create Session**: If this is a new feature or significant change, ask the user to run `/session-create` (or create it yourself if permitted).
- **Document Decisions**: Record all technical decisions (Option A vs B) in the session file.
- **Update Checklist**: Maintain the implementation checklist in the session file.

### 3. After Completion
- **Archive**: Remind the user to run `/session-archive`.
- **Update Indexes**: Help the user generate summaries for `docs/INDEX-*.md`.

### 4. Slash Commands (Workflows)
You can use the following slash commands to quickly execute session scripts:
- `/session-create`: Runs `../.agent/scripts/create-session.sh` to start a new session.
- `/session-archive`: Runs `../.agent/scripts/archive-session.sh` to archive the current session.
- `/changelog-update`: Runs `../.agent/scripts/update-changelog.sh` to update the changelog.

### 5. Directory Structure
- `docs/sessions/`: The source of truth for development history.
- `docs/INDEX-*.md`: Quick lookup for decisions, architecture, API, and features.
- `docs/CHANGELOG.md`: High-level version history.

## Development Conventions

*   **Language Preference:** Whenever possible, respond in Traditional Chinese.
*   **Spec-Driven Development:** All features are defined in the `/spec` directory before implementation.
*   **Commit-First Checks:** Before committing any code, all tests must be run and pass.
