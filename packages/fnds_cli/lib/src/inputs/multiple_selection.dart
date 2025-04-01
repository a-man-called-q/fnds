part of 'inputs.dart';

List<String> multipleSelect({
  Function()? label,
  required Function() question,
  required List<String> options,
  int width = 0,
  int gap = 0,
  Indicators indicators = const Indicators(),
  Function(List<String> values)? callback,
}) {
  List<bool> selectedOptions = List.generate(options.length, (index) => false);
  int currentIndex = 0;

  stdin.echoMode = false;
  stdin.lineMode = false;

  _renderQuestion(label, question, width, gap);

  final int padding = width + gap;
  final int optionCount = options.length;

  stdout.write('\x1B[?25l');

  while (true) {
    _renderOptionsMultiple(
      options,
      currentIndex,
      padding,
      selectedOptions,
      indicators,
    );

    final input = _readKey();

    if (_handleArrowKeyInput(input, optionCount, currentIndex)) {
      currentIndex = _updateCurrentIndex(input, optionCount, currentIndex);
      _clearOptions(optionCount);
      continue;
    }

    if (_handleEnterKeyInput(input)) {
      break;
    }

    if (_handleSpacebarInput(input)) {
      selectedOptions[currentIndex] = !selectedOptions[currentIndex];
    }

    _clearOptions(optionCount);
  }

  stdout.write('\x1B[?25h');
  stdin.lineMode = true;
  stdin.echoMode = true;

  final selectedValues =
      options
          .where((option) => selectedOptions[options.indexOf(option)])
          .toList();
  callback?.call(selectedValues);
  return selectedValues;
}

bool _handleArrowKeyInput(List<int> input, int optionCount, int currentIndex) {
  return input.length == 3 && input[0] == 27 && input[1] == 91;
}

bool _handleEnterKeyInput(List<int> input) {
  return input.length == 1 && (input[0] == 10 || input[0] == 13);
}

bool _handleSpacebarInput(List<int> input) {
  return input.length == 1 && input[0] == 32;
}

String _indicatorSelection(
  bool isMultiSelected,
  bool isSelected,
  Indicators indicators,
) {
  if (isMultiSelected && isSelected) {
    return indicators.selectedConfirmedIndicator; // Green checkmark
  }
  if (isMultiSelected) {
    return indicators.confirmedIndicator; // Green checkmark
  }
  if (isSelected) {
    return indicators.selectedIndicator; // Orange dot
  }
  return indicators.defaultIndicator; // Magenta circle
}

List<int> _readKey() {
  final input = [stdin.readByteSync()];

  if (input[0] == 27) {
    input.addAll([stdin.readByteSync(), stdin.readByteSync()]);
  }

  return input;
}

void _renderOptionsMultiple(
  List<String> options,
  int currentIndex,
  int padding,
  List<bool> selectedOptions,
  Indicators indicators,
) {
  for (int i = 0; i < options.length; i++) {
    final bool isSelected = i == currentIndex;
    final bool isMultiSelected = selectedOptions[i];

    String indicator = _indicatorSelection(
      isMultiSelected,
      isSelected,
      indicators,
    );

    var optionStringext = '$indicator ${options[i]}';

    print('${' ' * padding}$optionStringext');
  }
}

int _updateCurrentIndex(List<int> input, int optionCount, int currentIndex) {
  if (input[2] == 65) {
    return (currentIndex - 1 + optionCount) % optionCount;
  }
  if (input[2] == 66) {
    return (currentIndex + 1) % optionCount;
  }
  return currentIndex; // Default case (shouldn't happen)
}
