part of 'core.dart';

/// Defines the interface for providing interactive prompts (ask, confirm, etc.)
/// An implementation using the project's specific interactive functions
/// (from lib/src/inputs) must be provided to CliApp.
abstract class InteractivePrompter {
  /// Asks the user for a string input.
  /// Corresponds to the `ask<String>(...)` function.
  Future<String> askString({
    required String promptLabel, // Maps to 'label' in ask
    required String promptQuestion, // Displayed via 'question' in ask
    String? defaultValue,
    String? originalValue, // Value found in originalArgs, if any
    bool isSecretive = false,
  });

  /// Asks the user for a boolean confirmation (yes/no).
  /// Corresponds to the `confirm(...)` function.
  Future<bool> confirm({
    required String promptLabel, // Maps to 'label' in confirm
    required String promptQuestion, // Displayed via 'question' in confirm
    required bool defaultValue,
    bool? originalValue, // Original flag presence (true if found)
  });

  /// Asks the user to select multiple options from a list.
  /// Corresponds to the `multipleSelect<T>(...)` function.
  Future<List<T>> multiSelect<T>({
    required String promptLabel, // Maps to 'label' in multipleSelect
    required String
    promptQuestion, // Displayed via 'question' in multipleSelect
    required List<T> options,
    List<String>? optionLabels, // Maps to 'optionLabels'
    List<T>? defaultValues, // How to handle defaults for multi-select?
    List<T>? originalValues,
    // Add other parameters like 'indicators' if needed
  });

  /// Asks the user to select one option from a list.
  /// Corresponds to the `select<T>(...)` function.
  Future<T> select<T>({
    required String promptLabel, // Maps to 'label' in select
    required String promptQuestion, // Displayed via 'question' in select
    required List<T> options,
    List<String>? optionLabels, // Maps to 'optionLabels'
    T? defaultValue, // Maps to 'recommendedOption' logic in select
    T? originalValue,
    // Add other parameters like 'indicators' if needed by the interface
  });

  // Add other prompt types as needed
}
