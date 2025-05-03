part of 'commands.dart';

/// Configuration for an interactive fallback for a command argument.
///
/// Generic type [T] represents the type of value that will be returned by the fallback.
class InteractiveFallback<T> {
  /// The type of interactive input to use.
  final InteractiveInputType inputType;

  /// The question or prompt to display to the user.
  final String question;

  /// The label to display before the question.
  final String? label;

  /// For [InteractiveInputType.select] and [InteractiveInputType.multipleSelect],
  /// the list of options to select from.
  final List<dynamic>? options;

  /// For [InteractiveInputType.select] and [InteractiveInputType.multipleSelect],
  /// optional custom labels for the options.
  final List<String>? optionLabels;

  /// For [InteractiveInputType.ask] and [InteractiveInputType.confirm],
  /// the default value to suggest.
  final dynamic defaultValue;

  // Cache validation result to avoid multiple validations
  bool _validated = false;

  /// Creates a new instance of [InteractiveFallback].
  InteractiveFallback({
    required this.inputType,
    required this.question,
    this.label,
    this.options,
    this.optionLabels,
    this.defaultValue,
  });

  /// Validates configuration only when needed
  void validateIfNeeded() {
    if (_validated) return;

    // Perform specific validation based on input type
    switch (inputType) {
      case InteractiveInputType.select:
      case InteractiveInputType.multipleSelect:
        if (options == null || options!.isEmpty) {
          throw ArgumentError(
            'Options must be provided for ${inputType.name} input type.',
          );
        }
        break;
      case InteractiveInputType.ask:
        if (defaultValue == null) {
          throw ArgumentError(
            'Default value must be provided for ask input type.',
          );
        }
        break;
      case InteractiveInputType.confirm:
        if (defaultValue != null && defaultValue is! bool) {
          throw ArgumentError('Default value for confirm must be a boolean.');
        }
        break;
    }

    _validated = true;
  }
}

/// Manages interactive fallbacks for command arguments
class InteractiveFallbackManager {
  /// Runs the interactive fallback for a single argument.
  static T runFallback<T>(InteractiveFallback<T> fallback) {
    // Validate configuration just before use
    fallback.validateIfNeeded();

    switch (fallback.inputType) {
      case InteractiveInputType.ask:
        return _runAskFallback<T>(fallback);
      case InteractiveInputType.confirm:
        return _runConfirmFallback<T>(fallback);
      case InteractiveInputType.select:
        return _runSelectFallback<T>(fallback);
      case InteractiveInputType.multipleSelect:
        return _runMultipleSelectFallback<T>(fallback);
    }
  }

  /// Helper method for ask input type
  static T _runAskFallback<T>(InteractiveFallback<T> fallback) {
    return ask<T>(
      label: fallback.label,
      question: fallback.question,
      defaultValue: fallback.defaultValue as T,
    );
  }

  /// Helper method for confirm input type that handles type constraints
  static T _runConfirmFallback<T>(InteractiveFallback<T> fallback) {
    final result = confirm(
      label: fallback.label,
      question: fallback.question,
      defaultValue: (fallback.defaultValue as bool?) ?? true,
    );

    // Type checking is still needed here as it's a runtime check
    if (T == bool || T == dynamic) {
      return result as T;
    }

    throw ArgumentError(
      'Confirm input type requires boolean or dynamic return type, got $T.',
    );
  }

  /// Helper method for multiple select input type
  static T _runMultipleSelectFallback<T>(InteractiveFallback<T> fallback) {
    // This is a safe cast because we know that for MultipleSelectFallback<E>,
    // T will be List<E> and options will be List<E>
    final options = fallback.options!;

    final result = multipleSelect(
      label: fallback.label,
      question: fallback.question,
      options: options,
      optionLabels: fallback.optionLabels,
    );

    // Safe to cast because T should be List<Something>
    return result as T;
  }

  /// Helper method for select input type
  static T _runSelectFallback<T>(InteractiveFallback<T> fallback) {
    return select<T>(
      label: fallback.label,
      question: fallback.question,
      options: fallback.options! as List<T>,
      optionLabels: fallback.optionLabels,
      recommendedOption: fallback.defaultValue as T?,
    );
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

/// Specialized fallback for multiple selection that returns a list of items.
///
/// This class extends [InteractiveFallback] specifically for interactive inputs
/// that allow selecting multiple options from a list and returning them as a [List<E>].
///
/// The generic type [E] represents the element type of the options list and the resulting selected items.
///
/// Example usage:
/// ```dart
/// final fallback = MultipleSelectFallback<String>(
///   question: 'Select the features you want to enable:',
///   options: ['Authentication', 'Push Notifications', 'Analytics', 'Offline Support'],
/// );
///
/// // Use this fallback with InteractiveFallbackManager
/// final selectedFeatures = InteractiveFallbackManager.runFallback(fallback);
/// ```
class MultipleSelectFallback<E> extends InteractiveFallback<List<E>> {
  /// Creates a multiple selection interactive fallback.
  ///
  /// The [question] parameter is the prompt displayed to the user.
  /// The [options] parameter is the list of available items to select from.
  /// The [label] parameter is an optional label displayed before the question.
  /// The [optionLabels] parameter allows providing custom display text for each option.
  MultipleSelectFallback({
    required super.question,
    super.label,
    required List<E> super.options,
    super.optionLabels,
  }) : super(inputType: InteractiveInputType.multipleSelect);
}
