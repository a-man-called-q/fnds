dsa
## 🛠️ Tooling

*   **Language:** Dart
*   **Framework:** Flutter (for `demo` app and `fnds_layouts`)
*   **Monorepo Management:** Melos
*   **Linting:** `package:lints/recommended.yaml` (Configured via `analysis_options.yaml`)
*   **Testing:** Dart `test` package

## 🚀 Getting Started

### Prerequisites

*   Dart SDK (Version `^3.7.2` or compatible, as seen in `apps/cli`)
*   Flutter SDK (If working with `apps/demo` or `packages/fnds_layouts`)
*   Melos CLI:
    ```bash
    dart pub global activate melos
    ```
*   Git

### Starting to Contribute

1.  **Clone the repository:**
    ```bash
    git clone <your-repository-url> fnds
    cd fnds
    ```

2.  **Bootstrap the workspace:**
    This command links local packages and installs dependencies across the monorepo using Melos.
    ```bash
    melos bootstrap
    ```
    *(Alternatively: `melos bs`)*

## 💻 Development Workflow

Melos scripts (defined in `melos.yaml`) help run tasks across packages.

*(**Note:** The following assumes standard script names in `melos.yaml`. Please verify or update based on your actual `melos.yaml` configuration.)*

*   **Analyze code across all packages:**
    ```bash
    melos run analyze
    ```

*   **Run tests across all packages:**
    ```bash
    melos run test
    ```

*   **Format code across all packages:**
    ```bash
    melos run format # Or potentially 'melos run format:check' / 'melos run format:apply'
    ```

*   **Run the CLI application:**
    ```bash
    # Option 1: Using dart run with path context
    dart run -C apps/cli bin/cli.dart

    # Option 2: If a 'start:cli' script exists in melos.yaml
    # melos run start:cli --scope=cli
    ```

*   **Run the Flutter Demo application:**
    ```bash
    # Option 1: Using flutter run with path context
    flutter run -C apps/demo

    # Option 2: If a 'start:demo' script exists in melos.yaml
    # melos run start:demo --scope=demo
    ```

*   **Clean workspace artifacts:**
    ```bash
    melos clean
    ```

Refer to the `melos.yaml` file for all available scripts and their definitions.

## 🤝 Contributing

Contributions are welcome! Please follow standard procedures:

1.  Fork the repository.
2.  Create a feature branch (`git checkout -b feature/your-feature-name`).
3.  Make your changes.
4.  Ensure code passes analysis (`melos run analyze`) and tests (`melos run test`).
5.  Format your code (`melos run format`).
6.  Commit your changes (`git commit -m 'feat: Add some feature'`).
7.  Push to the branch (`git push origin feature/your-feature-name`).
8.  Open a Pull Request.

*(Optional: Consider creating a `CONTRIBUTING.md` file with more detailed guidelines.)*

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.
