part of 'inputs.dart';

String select({
  Function()? label,
  required Function() question,
  required List<String> options,
  String recommendedOption = '',
  int width = 0,
  int gap = 0,
  Function(String value)? callback,
  String recommendedText = '\x1B[38;5;240m(recommended)\x1B[0m',
  Indicators indicator = const Indicators(),
}) {
  final int selectedIndex = options.indexOf(recommendedOption);
  int currentIndex = selectedIndex == -1 ? 0 : selectedIndex;

  stdin.echoMode = false;
  stdin.lineMode = false;

  _renderQuestion(label, question, width, gap);

  final int padding = width + gap;
  final int optionCount = options.length;
  // ⬇️ **Hide the cursor**
  stdout.write('\x1B[?25l');

  while (true) {
    _renderOptions(
      options,
      currentIndex,
      padding,
      recommendedOption,
      indicator,
      recommendedText,
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

  final selectedValue = options[currentIndex];
  callback?.call(selectedValue);
  return selectedValue;
}

void _clearOptions(int lines) {
  for (int i = 0; i < lines; i++) {
    stdout.write('\x1B[1A\x1B[2K');
  }
}

void _renderOptions<String>(
  List<String> options,
  int currentIndex,
  int padding,
  String recommendedOption,
  Indicators indicators,
  String recommendedText,
) {
  for (int i = 0; i < options.length; i++) {
    final isSelected = i == currentIndex;
    final isRecommended = options[i] == recommendedOption;

    final indicator =
        isSelected ? indicators.selectedIndicator : indicators.defaultIndicator;

    var optionStringext = '$indicator ${options[i]}';

    if (isRecommended) {
      optionStringext += ' $recommendedText';
    }

    print('${' ' * padding}$optionStringext');
  }
}
