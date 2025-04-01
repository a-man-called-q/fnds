part of 'inputs.dart';

List<T> multipleSelect<T>({
  String? label,
  List<String>? optionLabels,
  required Function() question,
  required List<T> options,
  int width = 0,
  int gap = 0,
  Indicators indicators = const Indicators(),
  Function(MultipleCLIState<T> values)? callback,
}) {
  List<bool> selectedOptions = List.generate(options.length, (index) => false);
  int currentIndex = 0;

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

  stdout.write('\x1B[?25l');

  while (true) {
    _renderMultipleOptions(
      optionLabels: optionLabels,
      options: options,
      currentIndex: currentIndex,
      padding: padding,
      selectedOptions: selectedOptions,
      indicators: indicators,
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

  final List<T> selectedValues =
      options
          .where((option) => selectedOptions[options.indexOf(option)])
          .toList();
  callback?.call(MultipleCLIState<T>(label, selectedValues));
  return selectedValues;
}
