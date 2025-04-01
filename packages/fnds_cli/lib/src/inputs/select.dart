part of 'inputs.dart';

T select<T>({
  String? label,
  required Function() question,
  List<String>? optionLabels,
  required List<T> options,
  T? recommendedOption,
  int width = 0,
  int gap = 0,
  Function(SingleCLIState value)? callback,
  String recommendedText = '\x1B[38;5;240m(recommended)\x1B[0m',
  Indicators indicators = const Indicators(),
}) {
  if (optionLabels != null && optionLabels.length != options.length) {
    throw ArgumentError('optionLabels and options must have the same length');
  }
  if (recommendedOption != null && !options.contains(recommendedOption)) {
    throw ArgumentError('recommendedOption must be one of the options');
  }

  final int selectedIndex =
      recommendedOption != null ? options.indexOf(recommendedOption) : -1;
  int currentIndex = selectedIndex == -1 ? 0 : selectedIndex;

  stdin.echoMode = false;
  stdin.lineMode = false;

  _renderQuestion(
    label: () => print(label),
    question: question,
    width: IntWidth(width),
    gap: gap,
  );

  final int padding = width + gap;
  final int optionCount = options.length;
  // ⬇️ **Hide the cursor**
  stdout.write('\x1B[?25l');

  while (true) {
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

    if (input.length == 3 && input[0] == 27 && input[1] == 91) {
      if (input[2] == 65) {
        currentIndex = (currentIndex - 1 + optionCount) % optionCount;
      } else if (input[2] == 66) {
        currentIndex = (currentIndex + 1) % optionCount;
      }
    } else if (input.length == 1 && (input[0] == 10 || input[0] == 13)) {
      break;
    }

    _clearOptions(optionCount);
  }

  // ⬇️ **Restore the cursor**
  stdout.write('\x1B[?25h');
  stdin.lineMode = true;
  stdin.echoMode = true;

  final T selectedValue = options[currentIndex];
  callback?.call(SingleCLIState<T>(label, selectedValue));
  return selectedValue;
}
