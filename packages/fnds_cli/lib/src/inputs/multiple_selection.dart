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
  List<bool> selectedOptions = List.generate(options.length, (index) => false);
  int currentIndex = 0;

  stdin.echoMode = false;
  stdin.lineMode = false;

  _renderQuestion(
    label: label,
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
  callback?.call(GroupCLIState<T>(label, selectedValues));
  return selectedValues;
}
