part of '../card.dart';

/// Expandable/foldable card implementation
class FNDSFoldableCard extends StatefulWidget {
  final FNDSTopCardContent? top;
  final Widget expandedContent;
  final FNDSBottomCardContent? bottom;
  final Widget? trailing;
  final FNDSCardConfig config;
  final bool initiallyExpanded;
  final Duration animationDuration;
  final VoidCallback? onExpand;
  final VoidCallback? onCollapse;

  /// Widget builder for the expand/collapse control
  /// Receives current expanded state and toggle function
  final Widget Function(bool isExpanded, VoidCallback toggleExpanded)?
  expandIconBuilder;

  const FNDSFoldableCard({
    super.key,
    this.top,
    required this.expandedContent,
    this.bottom,
    this.trailing,
    this.config = const FNDSCardConfig(),
    this.initiallyExpanded = false,
    this.animationDuration = const Duration(milliseconds: 200),
    this.onExpand,
    this.onCollapse,
    this.expandIconBuilder,
  });

  @override
  State<FNDSFoldableCard> createState() => _FNDSFoldableCardState();
}

class _FNDSFoldableCardState extends State<FNDSFoldableCard> {
  late bool _isExpanded;

  @override
  Widget build(BuildContext context) {
    // Custom trailing widget with expand/collapse icon
    final Widget expandIcon =
        widget.expandIconBuilder != null
            ? widget.expandIconBuilder!(_isExpanded, _toggleExpanded)
            : _buildDefaultExpandIcon();

    // Combine with existing trailing widget if any
    final Widget combinedTrailing =
        widget.trailing != null
            ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [widget.trailing!, expandIcon],
            )
            : expandIcon;

    return FNDSCardBase(
      top: widget.top,
      content: AnimatedSize(
        duration: widget.animationDuration,
        child: _isExpanded ? widget.expandedContent : const SizedBox.shrink(),
      ),
      bottom: widget.bottom,
      trailing: combinedTrailing,
      config: widget.config,
      onTap: _toggleExpanded,
    );
  }

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  /// Creates a default expand icon without Material dependency
  Widget _buildDefaultExpandIcon() {
    return GestureDetector(
      onTap: _toggleExpanded,
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        child: Text(
          _isExpanded ? '▲' : '▼', // Unicode triangles as fallback
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        widget.onExpand?.call();
      } else {
        widget.onCollapse?.call();
      }
    });
  }
}
