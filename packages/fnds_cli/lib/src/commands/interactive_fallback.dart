part of 'commands.dart';

/// Configuration for an interactive fallback for a command argument.
class InteractiveFallback<T> {
  /// The type of interactive input to use.
  final InteractiveInputType inputType;

  /// The question or prompt to display to the user.
  final String question;

  /// The label to display before the question.
  final String? label;

  /// For [InteractiveInputType.select] and [InteractiveInputType.multipleSelect],
  /// the list of options to select from.
  final List<T>? options;

  /// For [InteractiveInputType.select] and [InteractiveInputType.multipleSelect],
  /// optional custom labels for the options.
  final List<String>? optionLabels;

  /// For [InteractiveInputType.ask] and [InteractiveInputType.confirm],
  /// the default value to suggest.
  final T? defaultValue;

  /// Creates a new instance of [InteractiveFallback].
  InteractiveFallback({
    required this.inputType,
    required this.question,
    this.label,
    this.options,
    this.optionLabels,
    this.defaultValue,
  }) {
    // Validate configuration based on input type
    if (inputType == InteractiveInputType.select ||
        inputType == InteractiveInputType.multipleSelect) {
      if (options == null || options!.isEmpty) {
        throw ArgumentError(
          'Options must be provided for select and multipleSelect input types.',
        );
      }
    }

    if (inputType == InteractiveInputType.ask && defaultValue == null) {
      throw ArgumentError('Default value must be provided for ask input type.');
    }
  }
}

/// Manages the interactive fallback process for command arguments.
class InteractiveFallbackManager {
  /// Runs the interactive fallback for a single argument.
  static T runFallback<T>(InteractiveFallback<T> fallback) {
    switch (fallback.inputType) {
      case InteractiveInputType.ask:
        return ask<T>(
          label: fallback.label,
          question: fallback.question,
          defaultValue: fallback.defaultValue as T,
        );
      case InteractiveInputType.confirm:
        return confirm(
              label: fallback.label,
              question: fallback.question,
              defaultValue: (fallback.defaultValue as bool?) ?? true,
            )
            as T;
      case InteractiveInputType.select:
        return select<T>(
          label: fallback.label,
          question: fallback.question,
          options: fallback.options!,
          optionLabels: fallback.optionLabels,
          recommendedOption: fallback.defaultValue,
        );
      case InteractiveInputType.multipleSelect:
        return multipleSelect<dynamic>(
              label: fallback.label,
              question: fallback.question,
              options: fallback.options!,
              optionLabels: fallback.optionLabels,
            )
            as T;
    }
  }
}

/// Defines the type of interactive input to use when a command fails.
enum InteractiveInputType {
  /// Use a text input prompt
  ask,

  /// Use a confirmation dialog
  confirm,

  /// Use a single selection menu
  select,

  /// Use a multiple selection menu
  multipleSelect,
}
