part of 'layouts.dart';

void row(
  List<Function()> columns, {
  List<Width> widths = const [], // Change to List<Width>
  List<String> aligns = const [],
  int gap = 2,
}) {
  // Capture outputs
  List<String> outputs =
      columns.map((fn) {
        StringBuffer buffer = StringBuffer();
        Zone.current
            .fork(
              specification: ZoneSpecification(
                print: (_, __, ___, line) => buffer.write(line),
              ),
            )
            .run(fn);
        return buffer.toString().trim();
      }).toList();

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
    String text = outputs[i];
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
