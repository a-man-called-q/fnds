# FNDS - Fondasi

> A collection of Dart and Flutter libraries and tools to help build better applications.

FNDS (pronounced "Fondasi") is an Indonesian word for *Foundation*, and also stands for *Flutter N Dart Stuff*. This monorepo contains a collection of packages and applications designed to provide a solid foundation for Dart and Flutter development.

## 📦 What's Inside

### CLI Tools

- **fnds_cli** - A lightweight and intuitive CLI framework for Dart applications, inspired by AstroJS CLI. Supports interactive prompts, nested commands, and argument processing.

### Libraries

- **fnds_logger** - A multi-platform, plug-and-play, ultra-lightweight logger for Flutter & Dart backend apps, powered by Drift.
- **fnds_kit** - A collection of Flutter widgets and utilities for building better Flutter applications.

### Demo Applications

- **demo** - A Flutter application that showcases the various libraries and components in the monorepo.

## 🛠️ Tooling

- **Language:** Dart
- **Framework:** Flutter (for `demo` app and `fnds_kit`)
- **Monorepo Management:** Melos
- **Linting:** `package:lints/recommended.yaml` (Configured via `analysis_options.yaml`)
- **Testing:** Dart `test` package

## 🚀 Getting Started

### Prerequisites

- Dart SDK (Version `^3.7.2` or compatible)
- Flutter SDK (If working with `apps/demo` or `packages/fnds_kit`)
- Melos CLI:
  ```bash
  dart pub global activate melos
  ```
- Git

### Starting to Contribute

1. **Clone the repository:**
   ```bash
   git clone https://github.com/a-man-called-q/fnds.git
   cd fnds
   ```

2. **Bootstrap the workspace:**
   This command links local packages and installs dependencies across the monorepo using Melos.
   ```bash
   melos bootstrap
   ```
   *(Alternatively: `melos bs`)*

## 💻 Development Workflow

Melos scripts (defined in `melos.yaml`) help run tasks across packages.

- **Analyze code across all packages:**
  ```bash
  melos run analyze
  ```

- **Run tests across all packages:**
  ```bash
  melos run test
  ```

- **Format code across all packages:**
  ```bash
  melos run format
  ```

- **Run the CLI application:**
  ```bash
  dart run -C apps/cli bin/cli.dart
  ```

- **Run the Flutter Demo application:**
  ```bash
  flutter run -C apps/demo
  ```

- **Clean workspace artifacts:**
  ```bash
  melos clean
  ```

Refer to the `melos.yaml` file for all available scripts and their definitions.

## 📚 Package Documentation

### fnds_cli

> A lightweight and intuitive CLI package for Dart, inspired by the user-friendly experience of the AstroJS CLI.

**Current Version:** 0.3.0 (pre-release)

**Features:**
- Interactive command prompts with selection, confirmation, and text input
- Nested command structure with unlimited levels
- State management for CLI applications
- Non-interactive mode for scripting
- Lightweight with minimal dependencies

[More details in the package README](/packages/fnds_cli/README.md)

### fnds_logger

> A multi-platform, plug-and-play, ultra-lightweight logger for Flutter & Dart backend apps.

**Features:**
- Works on both Flutter and backend
- Stores logs using SQLite
- Auto-prunes logs older than 7 days
- Upload/export logs easily
- Tiny footprint

This package is currently in early development.

[More details in the package README](/packages/fnds_logger/README.md)

### fnds_kit

> A collection of Flutter widgets and utilities

This package is currently in early development.

[More details in the package README](/packages/fnds_kit/README.md)

## 🤝 Contributing

Contributions are welcome! Please follow standard procedures:

1. Fork the repository.
2. Create a feature branch (`git checkout -b feature/your-feature-name`).
3. Make your changes.
4. Ensure code passes analysis (`melos run analyze`) and tests (`melos run test`).
5. Format your code (`melos run format`).
6. Commit your changes (`git commit -m 'feat: Add some feature'`).
7. Push to the branch (`git push origin feature/your-feature-name`).
8. Open a Pull Request.

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.
