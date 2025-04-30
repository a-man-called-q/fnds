part of 'layouts.dart';

/// Creates a horizontal row of text columns with customizable formatting.
///
/// The [row] function arranges text in columns with specified widths and alignments,
/// automatically calculating flexible column widths based on available terminal space.
///
/// Features:
/// - Supports fixed and auto-adjusting column widths
/// - Handles text alignment (left, right, center)
/// - Preserves ANSI color codes and formatting
/// - Automatically adapts to terminal width
///
/// Parameters:
/// - [columns]: List of strings to display in columns
/// - [widths]: Optional width specifications for each column
/// - [aligns]: Optional alignment for each column ('left', 'right', 'center')
/// - [gap]: Space between columns
///
/// Example:
/// ```dart
/// row(
///   ['Name', 'John Doe', 'Status: Active'],
///   widths: [IntWidth(10), AutoWidth(), IntWidth(20)],
///   aligns: ['right', 'left', 'center'],
///   gap: 2,
/// );
/// ```
void row(
  List<String> columns, {
  List<Width> widths = const [],
  List<String> aligns = const [],
  int gap = 2,
}) {
  int totalWidth = stdout.terminalColumns - (gap * (columns.length - 1));
  int assignedWidth = 0;
  int autoCount = 0;

  for (final width in widths) {
    if (width is IntWidth) {
      assignedWidth += width.value;
    } else if (width is AutoWidth) {
      autoCount++;
    }
  }

  int autoWidth = autoCount > 0 ? (totalWidth - assignedWidth) ~/ autoCount : 0;

  List<int> resolvedWidths =
      widths.map((width) {
        if (width is IntWidth) {
          return width.value;
        } else {
          return autoWidth;
        }
      }).toList();

  // Format columns
  List<String> formattedColumns = List.generate(columns.length, (i) {
    String text = columns[i];
    String strippedText = stripAnsi(text);
    int ansiCodeLength = text.length - strippedText.length;
    int adjustedWidth = resolvedWidths[i] + ansiCodeLength;

    switch (aligns.length > i ? aligns[i] : 'left') {
      case 'center':
        return text
            .padLeft((adjustedWidth + strippedText.length) ~/ 2)
            .padRight(adjustedWidth);
      case 'right':
        return text.padLeft(adjustedWidth);
      default:
        return text.padRight(adjustedWidth);
    }
  });

  stdout.writeln(formattedColumns.join(' ' * gap));
}
