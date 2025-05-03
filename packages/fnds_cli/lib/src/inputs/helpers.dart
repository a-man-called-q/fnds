part of 'inputs.dart';

/// Clears a specified number of lines from the terminal output.
///
/// This utility function moves the cursor up and clears lines, which is useful
/// for interactive CLI interfaces that need to update options or selections.
///
/// Parameters:
/// - [lines]: The number of lines to clear from the terminal
void _clearOptions(int lines) {
  for (int i = 0; i < lines; i++) {
    stdout.write('\x1B[1A\x1B[2K');
  }
}

/// Gets user input with a placeholder default value.
///
/// This function handles raw terminal input with support for default values,
/// cursor positioning, and password (secretive) mode. It manages clearing the
/// placeholder when the user starts typing.
///
/// Parameters:
/// - [defaultValue]: Default value shown as a placeholder
/// - [width]: Width of the input area
/// - [gap]: Space before the input area
/// - [isSecretive]: When true, hides user input (for passwords)
///
/// Returns the user's input as a string, or null if an error occurs.
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

/// Detects if input represents arrow key navigation.
///
/// Checks if the input byte sequence matches the pattern for arrow keys.
/// Arrow keys typically generate a 3-byte sequence starting with 27 (escape), 91.
///
/// Parameters:
/// - [input]: List of input bytes to check
/// - [optionCount]: Total number of available options (unused in this function)
/// - [currentIndex]: Current selection index (unused in this function)
///
/// Returns true if the input represents an arrow key press.
bool _handleArrowKeyInput(List<int> input, int optionCount, int currentIndex) {
  return input.length == 3 && input[0] == 27 && input[1] == 91;
}

/// Checks if the input represents an Enter key press.
///
/// Detects if the input is a single byte representing a carriage return (13)
/// or a line feed (10), which both indicate an Enter/Return key press.
///
/// Parameters:
/// - [input]: List of input bytes to check
///
/// Returns true if the input represents an Enter key press.
bool _handleEnterKeyInput(List<int> input) {
  return input.length == 1 && (input[0] == 10 || input[0] == 13);
}

/// Determines if the input represents a spacebar press.
///
/// Checks if the input is a single byte with the ASCII value 32,
/// which corresponds to a space character.
///
/// Parameters:
/// - [input]: List of input bytes to check
///
/// Returns true if the input represents a spacebar press.
bool _handleSpacebarInput(List<int> input) {
  return input.length == 1 && input[0] == 32;
}

/// Selects the appropriate indicator symbol based on selection state.
///
/// This function determines which visual indicator to display next to an option
/// based on whether it's currently selected, confirmed in a multi-select context,
/// or both.
///
/// Parameters:
/// - [isMultiSelected]: Whether the option is confirmed in a multi-select context
/// - [isSelected]: Whether the option is currently under cursor focus
/// - [indicators]: Object containing different indicator symbols to use
///
/// Returns the appropriate indicator string.
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

/// Converts a string input to the specified type.
///
/// Attempts to parse the input string to the generic type T.
/// Currently supports conversion to int and double types.
///
/// Parameters:
/// - [input]: String to parse into the target type
///
/// Returns the parsed value as type T, or throws a FormatException if parsing fails.
T _parseInput<T>(String input) {
  if (T == int) return int.tryParse(input) as T? ?? (throw FormatException());
  if (T == double) {
    return double.tryParse(input) as T? ?? (throw FormatException());
  }
  return input as T;
}

/// Reads a key press from standard input.
///
/// This function reads bytes from stdin and handles special cases for
/// escape sequences (like arrow keys) which generate multiple bytes.
/// Arrow keys generate a 3-byte sequence starting with 27 (escape).
///
/// Returns a List<int> containing the bytes read from stdin.
List<int> _readKey() {
  final input = [stdin.readByteSync()];

  if (input[0] == 27) {
    input.addAll([stdin.readByteSync(), stdin.readByteSync()]);
  }

  return input;
}

/// Renders a list of options for multi-selection interfaces.
///
/// Displays a list of options with appropriate indicators showing which ones
/// are currently selected (under cursor) and/or confirmed (via multi-select).
///
/// Parameters:
/// - [options]: List of options to display
/// - [optionLabels]: Optional custom labels to display instead of the option values
/// - [currentIndex]: Index of the currently selected option
/// - [padding]: Number of spaces to pad before each option
/// - [selectedOptions]: List of boolean flags indicating which options are confirmed
/// - [indicators]: Object containing indicator symbols to use for different states
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

/// Renders a list of single-select options with optional recommended option highlighting.
///
/// Displays a list of options with indicators showing which one is currently
/// selected and which one (if any) is recommended.
///
/// Parameters:
/// - [options]: List of options to display
/// - [optionLabels]: Optional custom labels to display instead of option values
/// - [currentIndex]: Index of the currently selected option
/// - [padding]: Number of spaces to pad before each option
/// - [recommendedOption]: Option to mark as recommended
/// - [indicators]: Object containing indicator symbols for different states
/// - [recommendedText]: Text to append to the recommended option
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

/// Renders a question prompt with optional label and instruction.
///
/// Creates a formatted question display with configurable layout for CLI interfaces.
/// The function uses a row-based layout system to position the question components.
///
/// Parameters:
/// - [label]: Optional label text to display before the question
/// - [instruction]: Optional instruction text to display after the question
/// - [question]: The main question text to display
/// - [width]: Width configuration for the label column
/// - [gap]: Spacing between columns
void _renderQuestion({
  String? label,
  String? instruction,
  required String question,
  required Width width,
  required int gap,
}) {
  stdout.write('\x1B[2K\r'); // Clear current line

  List<String> columns = [];
  List<Width> widths = [];
  List<String> aligns = [];

  if (label != null) {
    columns.add(" $label ");
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

/// Updates the currently selected option index based on arrow key input.
///
/// Handles the logic for navigating up or down in a list of options.
/// When the user presses the up arrow (65), it moves to the previous option.
/// When the user presses the down arrow (66), it moves to the next option.
/// The function wraps around at the beginning and end of the list.
///
/// Parameters:
/// - [input]: List of input bytes (expecting arrow key sequence)
/// - [optionCount]: Total number of available options
/// - [currentIndex]: Current selection index
///
/// Returns the new index after navigation.
int _updateCurrentIndex(List<int> input, int optionCount, int currentIndex) {
  if (input[2] == 65) {
    return (currentIndex - 1 + optionCount) % optionCount;
  }
  if (input[2] == 66) {
    return (currentIndex + 1) % optionCount;
  }
  return currentIndex; // Default case (shouldn't happen)
}
