part of 'card.dart';

/// Content for bottom section of cards
typedef FNDSBottomCardContent = FNDSCardContent;

/// Content for top section of cards
typedef FNDSTopCardContent = FNDSCardContent;

/// Base content container for card sections
class FNDSCardContent {
  final Widget? left;
  final Widget? center;
  final Widget? right;
  final Widget? all;

  /// If true, the content will not receive touch events
  final bool absorbPointer;

  const FNDSCardContent({
    this.left,
    this.center,
    this.right,
    this.all,
    this.absorbPointer = false,
  });

  bool get hasContent =>
      left != null || center != null || right != null || all != null;

  /// Creates a copy with modified properties
  FNDSCardContent copyWith({
    Widget? left,
    Widget? center,
    Widget? right,
    Widget? all,
    bool? absorbPointer,
  }) {
    return FNDSCardContent(
      left: left ?? this.left,
      center: center ?? this.center,
      right: right ?? this.right,
      all: all ?? this.all,
      absorbPointer: absorbPointer ?? this.absorbPointer,
    );
  }
}
