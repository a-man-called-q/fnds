part of 'card.dart';

/// Configuration for card styling and behavior
class FNDSCardConfig {
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? shadowColor;
  final double elevation;
  final double contentSpacing;
  final double sectionSpacing;
  final BoxConstraints? constraints;
  final bool inkWellEnabled;

  const FNDSCardConfig({
    this.padding = const EdgeInsets.all(16.0),
    this.borderRadius = 8.0,
    this.backgroundColor,
    this.shadowColor,
    this.elevation = 1.0,
    this.contentSpacing = 8.0,
    this.sectionSpacing = 16.0,
    this.constraints,
    this.inkWellEnabled = true,
  });

  /// Creates a copy with modified properties
  FNDSCardConfig copyWith({
    EdgeInsetsGeometry? padding,
    double? borderRadius,
    Color? backgroundColor,
    Color? shadowColor,
    double? elevation,
    double? contentSpacing,
    double? sectionSpacing,
    BoxConstraints? constraints,
    bool? inkWellEnabled,
  }) {
    return FNDSCardConfig(
      padding: padding ?? this.padding,
      borderRadius: borderRadius ?? this.borderRadius,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      shadowColor: shadowColor ?? this.shadowColor,
      elevation: elevation ?? this.elevation,
      contentSpacing: contentSpacing ?? this.contentSpacing,
      sectionSpacing: sectionSpacing ?? this.sectionSpacing,
      constraints: constraints ?? this.constraints,
      inkWellEnabled: inkWellEnabled ?? this.inkWellEnabled,
    );
  }
}
