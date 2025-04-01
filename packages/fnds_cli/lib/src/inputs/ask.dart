part of 'inputs.dart';

T ask<T>({
  Function()? label,
  Function(String error)? error,
  required Function() question,
  required T defaultValue,
  int width = 0,
  int gap = 0,
  bool isSecretive = false,
  Function(T value)? callback,
}) {
  while (true) {
    _renderQuestion(label, question, width, gap);
    stdout.write(' ' * (width + gap)); // Align user input

    String? input = _getInputWithPlaceholder(
      defaultValue: defaultValue.toString(),
      width: width,
      gap: gap,
      isSecretive: isSecretive,
    );

    if (input?.isEmpty ?? true) {
      callback?.call(defaultValue);
      return defaultValue;
    }

    try {
      T value = _parseInput<T>(input!);
      callback?.call(value);
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

T _parseInput<T>(String input) {
  if (T == int) return int.tryParse(input) as T? ?? (throw FormatException());
  if (T == double) {
    return double.tryParse(input) as T? ?? (throw FormatException());
  }
  return input as T;
}

void _renderQuestion(
  Function()? label,
  Function() question,
  int width,
  int gap,
) {
  stdout.write('\x1B[2K\r'); // Clear current line

  List<Function()> columns = label != null ? [label, question] : [question];
  List<dynamic> widths = label != null ? [width, 'auto'] : ['auto'];

  row(columns, widths: widths, aligns: ['right', 'left'], gap: gap);
}
