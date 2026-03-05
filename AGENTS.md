# Numix AI Ecosystem & Instructions

Welcome! You are an AI agent operating in the `numix` Flutter repository. 

To maintain maximum context efficiency and accuracy, we have migrated from this single monolithic file into a **Modular AI Architecture** located in the `.ai/` directory (inspired by tools like `aitmpl.com`).

Whenever you are tasked with a feature, you **MUST** explore and read the relevant `.ai/` files to understand your boundaries, skills, and exact rules.

## 📂 The `.ai/` Structure

### 🤖 Agents (`.ai/agents/`)
Specialized system prompts for distinct roles. Read these if you are doing a specific type of task:
- `ui-ux-agent.md`: Rules for Flutter widget tree, Material 3, animations, and responsive design.
- `qa-integration-agent.md`: Rules for self-healing testing loops and required math coverage.
- `devops-agent.md`: Rules for Native Android/iOS builds, Gradle, and CI/CD.
- `play-store-architect-agent.md`: Rules for Google Play policies, app signing, `.aab` bundling, and ProGuard.
- `tech-writer-agent.md`: Rules for documentation, READMEs, and code comments.

### 🎨 Skills (`.ai/skills/`)
Strict domain rulesets and coding standards. Read these before writing logic:
- `clean-architecture-skill.md`: Domain-Driven Feature-First constraints.
- `provider-state-skill.md`: How to use `ChangeNotifier`, `Consumer`, and memory persistence.
- `math-precision-skill.md`: Floating-point handling, `double.tryParse`, and advanced formulas.
- `git-ops-skill.md`: Conventional commits and atomic versioning.
- `devsecops-workflow-skill.md`: Git branch strategy (`dev` to `main`), secret blocking, and CI/CD pre-validation.

### ⚡ Commands (`.ai/commands/`)
Custom slash commands for rapid workflows:
- `verify-math.md`: Action list to run tests and analyze the codebase.

---

### Core Project Stack
- **Framework**: Flutter (Dart ^3.6.0)
- **State Management**: `provider` + `shared_preferences`
- **Architecture**: Domain-Driven Feature-First (`lib/features/`, `lib/core/`)

### Operational Rules
1. **Never execute destructive commands** (`git reset --hard`, `rm -rf`) without explicit user permission.
2. **Construct absolute paths** for file modifications.
3. **Evolution Mandate**: This ecosystem is a living structure. When a new library is added or a new architectural decision is made, do not hesitate to create a new `skill` or `agent` file inside `.ai/` to teach the rest of the AI tools how to use it.
