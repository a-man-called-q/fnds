part of 'card.dart';

/// Base implementation for all card variants without Material dependency
class FNDSCardBase extends StatelessWidget {
  final FNDSTopCardContent? top;
  final Widget? content;
  final FNDSBottomCardContent? bottom;
  final Widget? trailing;
  final FNDSCardConfig config;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const FNDSCardBase({
    super.key,
    this.top,
    this.content,
    this.bottom,
    this.trailing,
    this.config = const FNDSCardConfig(),
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    // Create a custom card using Container and BoxDecoration
    Widget card = Container(
      decoration: BoxDecoration(
        color:
            config.backgroundColor ?? const Color(0xFFFFFFFF), // Default white
        borderRadius: BorderRadius.circular(config.borderRadius),
        boxShadow:
            config.elevation > 0
                ? [
                  BoxShadow(
                    color:
                        config.shadowColor?.withAlpha(50) ??
                        const Color(0xFF000000).withAlpha(50),
                    blurRadius: config.elevation * 2,
                    spreadRadius: config.elevation / 2,
                    offset: Offset(0, config.elevation / 2),
                  ),
                ]
                : null,
      ),
      padding: config.padding,
      child: buildCardContent(),
    );

    if (config.constraints != null) {
      card = ConstrainedBox(constraints: config.constraints!, child: card);
    }

    if (onTap != null || onLongPress != null) {
      return GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        behavior: HitTestBehavior.opaque,
        child: card,
      );
    }

    return card;
  }

  /// Builds the card content with top, main, and bottom sections
  Widget buildCardContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Top section
        CardLayout.buildContentRow(
          top,
          config.contentSpacing,
          trailing: trailing,
        ),

        // Add spacing if both top and content exist
        if (top != null && top!.hasContent && content != null)
          SizedBox(height: config.sectionSpacing),

        // Main content
        if (content != null) content!,

        // Add spacing if both content and bottom exist
        if (content != null && bottom != null && bottom!.hasContent)
          SizedBox(height: config.sectionSpacing),

        // Bottom section
        CardLayout.buildContentRow(bottom, config.contentSpacing),
      ],
    );
  }
}
