part of 'inputs.dart';

/// Displays a single selection menu with various options and returns the selected value.
///
/// The [select] function allows users to navigate through options using arrow keys and
/// select one with the Enter key. It handles display formatting, user interaction,
/// and returns the selected value of type [T].
///
/// Parameters:
/// - [label]: Optional label displayed at the start of the prompt
/// - [question]: The question or prompt text shown to the user
/// - [optionLabels]: Optional custom labels for options
/// - [options]: List of available options of type [T]
/// - [recommendedOption]: Suggests a default option
/// - [width]: Width for the label column
/// - [gap]: Space between columns
/// - [callback]: Function called with the selected value
/// - [recommendedText]: Text displayed next to the recommended option
/// - [indicators]: Custom indicators for selected/unselected options
///
/// Returns the selected value of type [T].
///
/// Throws [ArgumentError] if:
/// - optionLabels length doesn't match options length
/// - recommendedOption is not in the options list
T select<T>({
  String? label,
  required String question,
  List<String>? optionLabels,
  required List<T> options,
  T? recommendedOption,
  int width = 0,
  int gap = 0,
  Function(SingleCLIState value)? callback,
  String recommendedText = '\x1B[38;5;240m(recommended)\x1B[0m',
  Indicators indicators = const Indicators(),
}) {
  // Validate inputs once at the beginning
  if (optionLabels != null && optionLabels.length != options.length) {
    throw ArgumentError('optionLabels and options must have the same length');
  }

  if (recommendedOption != null && !options.contains(recommendedOption)) {
    throw ArgumentError('recommendedOption must be one of the options');
  }

  // Calculate the starting index once
  final int recommendedIndex =
      recommendedOption != null ? options.indexOf(recommendedOption) : -1;

  int currentIndex = recommendedIndex >= 0 ? recommendedIndex : 0;
  final int optionCount = options.length;
  final int padding = width + gap;

  // Prepare terminal
  stdin.echoMode = false;
  stdin.lineMode = false;

  // Render the question once
  _renderQuestion(
    label: label,
    question: question,
    width: IntWidth(width),
    gap: gap,
  );

  // Hide cursor
  stdout.write('\x1B[?25l');

  try {
    // Main selection loop
    while (true) {
      // Render options with pre-calculated values
      _renderOptions(
        options: options,
        optionLabels: optionLabels,
        currentIndex: currentIndex,
        padding: padding,
        recommendedOption: recommendedOption,
        indicators: indicators,
        recommendedText: recommendedText,
      );

      final input = _readKey();

      // Process key input
      if (input.length == 3 && input[0] == 27 && input[1] == 91) {
        // Arrow keys (up/down navigation)
        if (input[2] == 65) {
          // Up arrow
          currentIndex = (currentIndex - 1 + optionCount) % optionCount;
        } else if (input[2] == 66) {
          // Down arrow
          currentIndex = (currentIndex + 1) % optionCount;
        }
      } else if (input.length == 1) {
        if (input[0] == 10 || input[0] == 13) {
          // Enter key
          break; // Exit the loop when selection is made
        }
      }

      _clearOptions(optionCount);
    }

    // Return the selected value
    final T selectedValue = options[currentIndex];

    // Call the callback if provided
    if (callback != null) {
      final state = SingleCLIState<T>(label ?? 'selection', selectedValue);
      callback(state);
    }

    return selectedValue;
  } finally {
    // Always ensure terminal is restored to original state
    stdout.write('\x1B[?25h'); // Show cursor
    stdin.lineMode = true;
    stdin.echoMode = true;
  }
}
