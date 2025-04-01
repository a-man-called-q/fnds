part of 'utils.dart';

// Regex to detect ANSI escape codes
final _ansiRegex = RegExp(r'(\x1B\[[0-9;]*m)');

Future<void> typewriter(
  String text, {
  int delay = 80, // Adjusted for per-word effect
  int styleDelay = 30,
  int clearDelay = 1200,
  bool resetAfterFinished = false,
}) async {
  final matches = _ansiRegex.allMatches(text).toList();
  int lastIndex = 0;

  for (final match in matches) {
    // Print normal text up to the ANSI code
    String normalText = text.substring(lastIndex, match.start);
    List<String> words = normalText.split(' ');

    for (int i = 0; i < words.length; i++) {
      stdout.write(words[i]);
      if (i < words.length - 1) stdout.write(' '); // Preserve spaces
      await Future.delayed(Duration(milliseconds: delay));
    }

    // Print ANSI code instantly (styling)
    stdout.write(match.group(0));
    await Future.delayed(Duration(milliseconds: styleDelay));

    lastIndex = match.end;
  }

  // Print any remaining text after the last ANSI code
  String remainingText = text.substring(lastIndex);
  List<String> words = remainingText.split(' ');

  for (int i = 0; i < words.length; i++) {
    stdout.write(words[i]);
    if (i < words.length - 1) stdout.write(' ');
    await Future.delayed(Duration(milliseconds: delay));
  }

  if (resetAfterFinished) {
    await Future.delayed(Duration(milliseconds: clearDelay));
    stdout.write('\x1B[2K\r'); // Clear current line and return to start
  } else {
    stdout.writeln(); // Move to next line if not resetting
  }
}
