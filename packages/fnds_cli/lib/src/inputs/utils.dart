part of 'inputs.dart';

void _clearOptions(int lines) {
  for (int i = 0; i < lines; i++) {
    stdout.write('\x1B[1A\x1B[2K');
  }
}

String? _getInputWithPlaceholder({
  required String defaultValue,
  required int width,
  required int gap,
  bool isSecretive = false,
}) {
  stdin.echoMode = false;
  stdin.lineMode = false;

  if (!isSecretive) {
    stdout.write('\x1B[90m$defaultValue\x1B[0m');
  }

  String input = '';
  int cursorPosition = 0;
  bool placeholderCleared = false;

  while (true) {
    final byte = stdin.readByteSync();

    // Ignore arrow key input
    if (byte == 27) {
      stdin.readByteSync();
      stdin.readByteSync();
      continue;
    }

    // Handle Enter key
    if (byte == 10 || byte == 13) {
      stdout.writeln();
      break;
    }

    // Handle Backspace
    if (byte == 127) {
      if (cursorPosition > 0) {
        input = input.substring(0, input.length - 1);
        stdout.write('\x1B[1D \x1B[1D');
        cursorPosition--;
      }
      continue;
    }

    // Handle regular character input
    if (!placeholderCleared) {
      stdout.write('\x1B[2K\r${' ' * (width + gap)}');
      placeholderCleared = true;
      cursorPosition = 0;
    }

    input += String.fromCharCode(byte);
    stdout.write(isSecretive ? '' : String.fromCharCode(byte));
    cursorPosition++;
  }

  stdin.echoMode = true;
  stdin.lineMode = true;

  return input;
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

T _parseInput<T>(String input) {
  if (T == int) return int.tryParse(input) as T? ?? (throw FormatException());
  if (T == double) {
    return double.tryParse(input) as T? ?? (throw FormatException());
  }
  return input as T;
}

List<int> _readKey() {
  final input = [stdin.readByteSync()];

  if (input[0] == 27) {
    input.addAll([stdin.readByteSync(), stdin.readByteSync()]);
  }

  return input;
}

void _renderMultipleOptions<T>({
  required List<T> options,
  required List<String>? optionLabels,
  required int currentIndex,
  required int padding,
  required List<bool> selectedOptions,
  required Indicators indicators,
}) {
  for (int i = 0; i < options.length; i++) {
    final bool isSelected = i == currentIndex;
    final bool isMultiSelected = selectedOptions[i];

    String indicator = _indicatorSelection(
      isMultiSelected,
      isSelected,
      indicators,
    );

    var optionStringext = '$indicator ${optionLabels?[i] ?? options[i]}';

    print('${' ' * padding}$optionStringext');
  }
}

void _renderOptions<String>({
  required List<String> options,
  List<String>? optionLabels,
  required int currentIndex,
  required int padding,
  required String recommendedOption,
  required Indicators indicators,
  required String recommendedText,
}) {
  for (int i = 0; i < options.length; i++) {
    final isSelected = i == currentIndex;
    final isRecommended = options[i] == recommendedOption;

    final indicator =
        isSelected ? indicators.selectedIndicator : indicators.defaultIndicator;

    var optionStringext = '$indicator ${optionLabels?[i] ?? options[i]}';

    if (isRecommended) {
      optionStringext += ' $recommendedText';
    }

    print('${' ' * padding}$optionStringext');
  }
}

void _renderQuestion({
  Function()? label,
  Function()? instruction,
  required Function() question,
  required Width width,
  required int gap,
}) {
  stdout.write('\x1B[2K\r'); // Clear current line

  List<Function()> columns = [];
  List<Width> widths = [];
  List<String> aligns = [];

  if (label != null) {
    columns.add(label);
    widths.add(width);
    aligns.add('right');
  }

  columns.add(question);
  widths.add(AutoWidth());
  aligns.add('left');

  if (instruction != null) {
    columns.add(instruction);
    widths.add(AutoWidth());
    aligns.add('left');
  }

  row(columns, widths: widths, aligns: aligns, gap: gap);
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
