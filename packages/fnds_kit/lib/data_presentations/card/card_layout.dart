part of 'card.dart';

/// Layout utilities for cards
class CardLayout {
  /// Helper method to build an aligned widget in a row
  static Widget buildAlignedWidget(
    Widget? widget,
    Alignment alignment, {
    bool absorbPointer = false,
  }) {
    if (widget == null) return const Spacer();

    Widget result = Expanded(child: Align(alignment: alignment, child: widget));

    if (absorbPointer) {
      return AbsorbPointer(child: result);
    }

    return result;
  }

  /// Builds section row layout with consistent handling
  static Widget buildContentRow(
    FNDSCardContent? content,
    double spacing, {
    Widget? trailing,
  }) {
    if (content == null || !content.hasContent) {
      return const SizedBox.shrink();
    }

    if (content.all != null) {
      final Widget allWidget =
          content.absorbPointer
              ? AbsorbPointer(child: content.all!)
              : content.all!;

      return trailing != null
          ? Row(children: [Expanded(child: allWidget), trailing])
          : allWidget;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildAlignedWidget(
          content.left,
          Alignment.centerLeft,
          absorbPointer: content.absorbPointer,
        ),

        if (content.center != null) ...[
          SizedBox(width: spacing),
          buildAlignedWidget(
            content.center,
            Alignment.center,
            absorbPointer: content.absorbPointer,
          ),
          SizedBox(width: spacing),
        ],

        buildAlignedWidget(
          content.right,
          Alignment.centerRight,
          absorbPointer: content.absorbPointer,
        ),

        if (trailing != null) trailing,
      ],
    );
  }
}
