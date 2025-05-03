part of '../card.dart';

/// Standard card implementation
class FNDSDefaultCard extends FNDSCardBase {
  const FNDSDefaultCard({
    super.key,
    super.top,
    super.content,
    super.bottom,
    super.trailing,
    super.config = const FNDSCardConfig(),
    super.onTap,
    super.onLongPress,
  });

  /// Creates a card with simplified content parameters
  factory FNDSDefaultCard.simple({
    Key? key,
    Widget? title,
    Widget? subtitle,
    Widget? leading,
    Widget? trailing,
    Widget? content,
    List<Widget>? actions,
    FNDSCardConfig config = const FNDSCardConfig(),
    VoidCallback? onTap,
    VoidCallback? onLongPress,
  }) {
    return FNDSDefaultCard(
      key: key,
      top: FNDSTopCardContent(
        left: leading,
        center: title,
        right: trailing,
        absorbPointer: true, // Prevent accidental taps on header elements
      ),
      content: content,
      bottom:
          actions != null
              ? FNDSBottomCardContent(
                all: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: actions,
                ),
              )
              : null,
      config: config,
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }
}
