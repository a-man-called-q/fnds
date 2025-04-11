part of 'inputs.dart';

T ask<T>({
  String? label,
  Function(String error)? error,
  required Function() question,
  Function()? instruction,
  required T defaultValue,
  int width = 0,
  int gap = 0,
  bool isSecretive = false,
  Function(SingleCLIState<T> values)? callback,
}) {
  while (true) {
    _renderQuestion(
      label: () => print(label),
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
