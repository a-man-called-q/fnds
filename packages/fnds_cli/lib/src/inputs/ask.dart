part of 'inputs.dart';

/// Prompts the user for input with a specific type and returns the validated value.
///
/// The [ask] function displays a question prompt and collects user input with support
/// for default values, password (secretive) mode, and type validation. It will keep
/// prompting until valid input is received.
///
/// Parameters:
/// - [label]: Optional label displayed at the start of the prompt
/// - [error]: Custom error handler function for invalid input
/// - [question]: The question or prompt text shown to the user
/// - [defaultValue]: Default value used if the user provides no input
/// - [width]: Width for the label column
/// - [gap]: Space between columns
/// - [isSecretive]: When true, hides user input (password mode)
/// - [callback]: Function called with the final validated input
///
/// Returns the validated input value of type [T].
///
/// Generic type [T] supports String, int, and double values.
T ask<T>({
  String? label,
  Function(String error)? error,
  required String question,
  required T defaultValue,
  int width = 0,
  int gap = 0,
  bool isSecretive = false,
  Function(SingleCLIState<T> values)? callback,
}) {
  while (true) {
    _renderQuestion(
      label: label,
      question: question,
      width: IntWidth(width),
      gap: gap,
    );
    stdout.write(' ' * (width + gap)); // Align user input

    String? input = _getInputWithPlaceholder(
      defaultValue: defaultValue.toString(),
      width: width,
      gap: gap,
      isSecretive: isSecretive,
    );

    if (input != null && input.isEmpty) {
      callback?.call(SingleCLIState<T>(label, defaultValue));
      return defaultValue;
    }

    try {
      T value = _parseInput<T>(input!);
      callback?.call(SingleCLIState<T>(label, value));
      return value;
    } catch (_) {
      stdout.write('\x1B[1A\x1B[2K\r${' ' * (width + gap)}');
      if (error != null) {
        error.call(T.toString());
      } else {
        print('\x1B[31m(x) Invalid input. Expected ${T.toString()}.\x1B[0m');
      }
    }
  }
}
