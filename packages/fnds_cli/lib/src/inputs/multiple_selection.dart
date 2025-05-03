part of 'inputs.dart';

/// Creates a multiple selection interface that allows users to select multiple options.
///
/// The [multipleSelect] function displays a list of options that users can navigate through
/// using arrow keys and toggle selection with the spacebar. Selections are confirmed with Enter.
///
/// Parameters:
/// - [label]: Optional label displayed at the start of the prompt
/// - [optionLabels]: Optional custom labels for options
/// - [question]: The question or prompt text shown to the user
/// - [options]: List of available options of type [T]
/// - [width]: Width for the label column
/// - [gap]: Space between columns
/// - [indicators]: Custom indicators for selected/unselected options
/// - [callback]: Function called with the selected values
///
/// Returns a list of selected values of type [T].
List<T> multipleSelect<T>({
  String? label,
  List<String>? optionLabels,
  required String question,
  required List<T> options,
  int width = 0,
  int gap = 0,
  Indicators indicators = const Indicators(),
  Function(GroupCLIState<T> values)? callback,
}) {
  // Validate inputs
  if (optionLabels != null && optionLabels.length != options.length) {
    throw ArgumentError('optionLabels and options must have the same length');
  }

  if (options.isEmpty) {
    // Return empty list immediately if no options
    final emptyResult = <T>[];
    callback?.call(GroupCLIState<T>(label ?? 'multi-selection', emptyResult));
    return emptyResult;
  }

  // Pre-calculate constants
  final int padding = width + gap;
  final int optionCount = options.length;

  // Initialize selection state
  final List<bool> selectedOptions = List.generate(optionCount, (_) => false);
  int currentIndex = 0;

  // Configure terminal
  stdin.echoMode = false;
  stdin.lineMode = false;

  // Render question once
  _renderQuestion(
    label: label,
    question: question,
    width: IntWidth(width),
    gap: gap,
  );

  // Hide cursor during selection
  stdout.write('\x1B[?25l');

  try {
    while (true) {
      // Render current state
      _renderMultipleOptions(
        optionLabels: optionLabels,
        options: options,
        currentIndex: currentIndex,
        padding: padding,
        selectedOptions: selectedOptions,
        indicators: indicators,
      );

      // Get user input
      final input = _readKey();

      // Process arrow keys (navigation)
      if (_handleArrowKeyInput(input, optionCount, currentIndex)) {
        currentIndex = _updateCurrentIndex(input, optionCount, currentIndex);
      }
      // Process Enter key (confirm)
      else if (_handleEnterKeyInput(input)) {
        break;
      }
      // Process Space key (toggle selection)
      else if (_handleSpacebarInput(input)) {
        selectedOptions[currentIndex] = !selectedOptions[currentIndex];
      }

      // Clear for redrawing
      _clearOptions(optionCount);
    }

    // Create result list efficiently
    final List<T> selectedValues = <T>[];
    for (int i = 0; i < options.length; i++) {
      if (selectedOptions[i]) {
        selectedValues.add(options[i]);
      }
    }

    // Call callback if provided
    if (callback != null) {
      final state = GroupCLIState<T>(
        label ?? 'multi-selection',
        selectedValues,
      );
      callback(state);
    }

    return selectedValues;
  } finally {
    // Restore terminal state
    stdout.write('\x1B[?25h'); // Show cursor
    stdin.lineMode = true;
    stdin.echoMode = true;
  }
}
