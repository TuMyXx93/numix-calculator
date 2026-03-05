# Agent AI Instructions & Ecosystem (AGENTS.md) - Numix

Welcome! You are an AI agent operating in the `numix` Flutter repository. This is a **living document**. As the project evolves, you and your subagents are expected to update this file with new architectural decisions, learned patterns, and new skills.

## 1. AI Ecosystem & Architecture
Our AI-driven development environment consists of the following structure:
- **Main Agent (You)**: Acts as the orchestrator, planner, and primary executor. Always plan before acting.
- **Subagents**: 
  - `explore`: For deep codebase searches.
  - `devops-agent`: Specialized in native compilation issues (Gradle, Kotlin, AGP).
  - `dart-analyzer-agent`: Fixes dependency resolution (`pub get`) and static typing errors autonomously.
  - `ui-ux-agent`: Specialist in Flutter widget tree optimization, Material Design 3, animations, and accessible, modern UIs.
  - `qa-integration-agent`: Specialist in E2E testing and Widget Tests to ensure robust user flows.
  - `tech-writer-agent`: Specialist in keeping README.md, code comments, and project documentation up to date with architectural changes.
- **Skills**: Load specific domain skills via the `skill` tool when available:
  - `git-ops-skill`: Enforces Conventional Commits (feat, fix, refactor, chore) and atomic commits after each logical phase.
  - `kotlin-compatibility-skill`: Resolves Kotlin/Gradle version mismatches.
  - `log-filter-skill`: Filters OEM noise from Flutter logs.
  - `clean-architecture-skill`: Acts as an architectural linter to enforce the Domain-Driven Feature-First rule.
  - `provider-state-skill`: Enforces correct usage of `context.read()`, `context.watch()`, and `Consumer` to prevent UI jank.
  - `math-precision-skill`: Enforces strict number formatting and precision (e.g., handling floating point errors).
- **Evolution Mandate**: Proactively propose updates to this AGENTS.md file as new features or libraries are added.

## 2. Project Context & Stack
- **Project Name**: Numix (Professional Math Suite)
- **Framework**: Flutter (Dart ^3.6.0)
- **State Management**: `provider` (Standardized for this project)
- **Math Engine**: `math_expressions` (Avoid `dart:math` for direct String evaluation to prevent crashes).
- **Architecture**: Domain-Driven Feature-First (e.g., `lib/features/calculator`, `lib/core/`).

## 3. Core Commands (Build, Lint, Test)

### Building & Running
- **Dependencies**: `flutter pub get` (Auto-run `flutter pub add <package>` if missing).
- **Run App**: `flutter run`
- **Clean**: `flutter clean && flutter pub get`

### Linting & Formatting
- **Analyze Code**: `flutter analyze` *(Must pass before considering a task complete)*
- **Format Code**: `dart format lib test`

### Testing & Self-Healing
- **Run All Tests**: `flutter test`
- *Agent Rule*: Use testing as a self-verification loop. For a math suite, 100% unit test coverage on the calculation engine is mandatory. 

## 4. Code Style & Guidelines

### 4.1 Naming Conventions
- **Classes/Enums**: `UpperCamelCase` (e.g., `CalculatorProvider`).
- **Files/Directories**: `snake_case` (e.g., `calculator_provider.dart`).
- **Variables/Methods**: `lowerCamelCase` (e.g., `evaluateExpression()`).
- **Private Members**: Prefix with `_`.

### 4.2 State Management & Architecture Rules (CRITICAL)
- **Isolate Logic**: NO mathematical logic or string parsing should live inside a Widget. All evaluations must happen in a UseCase, Service, or Provider.
- **Provider Usage**: Use `ChangeNotifier` and `Consumer`. Use `context.read()` for events (like button taps) and `context.watch()` only where UI rebuilding is needed.
- **Precision**: Be careful with standard `double` arithmetic (e.g., 0.1 + 0.2). Always format output string precisely to avoid `0.30000000000000004` errors in the UI.

### 4.3 Types, Null Safety, & Errors
- Dart is strongly typed and null-safe. Always declare return types.
- **Strict Casting**: Avoid blindly using the bang operator `!` on objects.
- **Math Exceptions**: Always wrap the evaluator `parse()` or `evaluate()` in `try/catch` to handle "FormatExceptions" when the user inputs invalid math syntax (e.g., `5 + * 2`). Return a clean error string like "Error" to the UI.

## 5. Operational Rules
1. **Never execute destructive commands** (`git reset --hard`, `rm -rf`) without explicit user permission.
2. **Construct absolute paths** for file modifications.
3. **Minimize verbosity**: Communicate with the user concisely. Let your code and tool usage do the talking.
4. **Log Filtering**: During `flutter run`, ignore verbose hardware/C++ errors (e.g., `gralloc4`, `Impeller`) specific to OEM implementations (like MIUI/Xiaomi) unless they result in a fatal app crash.