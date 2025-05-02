# Contributing to FNDS (Fondasi)

Thank you for your interest in contributing to FNDS! This document provides guidelines and instructions to help you contribute effectively.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
  - [Setting Up the Development Environment](#setting-up-the-development-environment)
  - [Understanding the Monorepo Structure](#understanding-the-monorepo-structure)
- [Development Workflow](#development-workflow)
  - [Making Changes](#making-changes)
  - [Testing Your Changes](#testing-your-changes)
  - [Documentation](#documentation)
- [Submitting Contributions](#submitting-contributions)
  - [Pull Request Process](#pull-request-process)
  - [Code Review](#code-review)
- [Package-Specific Guidelines](#package-specific-guidelines)
- [Release Process](#release-process)

## Code of Conduct

We expect all contributors to follow our Code of Conduct. Please be respectful and constructive in all communications and interactions within the project.

## Getting Started

### Setting Up the Development Environment

1. **Prerequisites:**
   - Dart SDK (Version ^3.7.2)
   - Flutter SDK (for Flutter-related packages)
   - Visual Studio Code, Android Studio, or your preferred IDE
   - Melos CLI: `dart pub global activate melos`

2. **Clone the repository:**
   ```bash
   git clone https://github.com/a-man-called-q/fnds.git
   cd fnds
   ```

3. **Bootstrap the workspace:**
   ```bash
   melos bootstrap
   ```
   This command links local packages together and installs all external dependencies.

### Understanding the Monorepo Structure

The repository is structured as a monorepo containing multiple packages:

- `/packages/fnds_cli`: A CLI framework for Dart applications
- `/packages/fnds_logger`: A lightweight logging solution
- `/packages/fnds_kit`: Flutter widgets and utilities
- `/apps/cli`: A sample CLI application using the framework
- `/apps/demo`: A Flutter demo application

## Development Workflow

### Making Changes

1. **Create a new branch:**
   ```bash
   git checkout -b feature/my-feature
   ```
   Use prefixes like `feature/`, `bugfix/`, `docs/`, etc.

2. **Follow our coding standards:**
   - Use the Dart style guide
   - Keep code modular and testable
   - Write meaningful commit messages following [Conventional Commits](https://www.conventionalcommits.org/)
   - Comment your code where necessary

3. **Run formatter and analyzer before committing:**
   ```bash
   melos run format
   melos run analyze
   ```

### Testing Your Changes

1. **Write tests for your code:**
   - Each new feature should have corresponding tests
   - Aim for high test coverage

2. **Run tests locally:**
   ```bash
   # Run all tests
   melos run test
   
   # Run tests for a specific package
   cd packages/fnds_cli
   dart test
   ```

3. **Verify examples work:**
   Make sure the examples in the package's `example/` directory still work with your changes.

### Documentation

1. **Update documentation for your changes:**
   - Add dartdoc comments to public APIs
   - Update the package README.md if applicable
   - Consider adding examples for significant features

2. **Generate API documentation if needed:**
   ```bash
   cd packages/your_package
   dart doc
   ```

## Submitting Contributions

### Pull Request Process

1. **Push your changes:**
   ```bash
   git push origin feature/my-feature
   ```

2. **Create a pull request:**
   - Fill out the PR template completely
   - Link to any relevant issues
   - Provide a clear description of the changes

3. **Update your PR as needed:**
   - Address review feedback
   - Keep the PR focused on a single issue/feature

### Code Review

1. **Be responsive to feedback:**
   - All PRs require review before merging
   - Be open to suggestions and constructive criticism

2. **Review PRs from others:**
   - Help the community by reviewing others' PRs
   - Be constructive and respectful in reviews

## Package-Specific Guidelines

### fnds_cli

- Ensure backwards compatibility for public APIs
- Test with both interactive and non-interactive modes
- Follow command-line interface best practices

### fnds_logger

- Keep the package lightweight and minimal
- Test on multiple platforms (Flutter/Dart)
- Consider performance implications

### fnds_kit

- Follow Flutter widget best practices
- Include widget tests for UI components
- Consider accessibility in widget design

## Release Process

1. **Version bumping:**
   - Follow semantic versioning
   - Update CHANGELOG.md with changes

2. **Publishing:**
   - Package owners will handle publishing to pub.dev
   - Document breaking changes clearly

---

Thank you for contributing to FNDS! Your efforts help make this project better for everyone.