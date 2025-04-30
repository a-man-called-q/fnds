part of 'inputs.dart';

/// A class that defines the visual indicators used in CLI selection interfaces.
///
/// This class allows customization of the appearance of selection indicators
/// in interactive command-line prompts, providing different symbols for various
/// selection states:
///
/// * [selectedIndicator] - Shown for the currently highlighted/selected item
/// * [defaultIndicator] - Shown for non-selected items
/// * [confirmedIndicator] - Shown for items that have been confirmed/selected
/// * [selectedConfirmedIndicator] - Shown for items that are both currently selected
///   and have been previously confirmed
///
/// Each indicator uses ANSI escape sequences for colored output in terminal
/// environments that support it.
///
/// Example usage:
/// ```dart
/// final customIndicators = Indicators(
///   selectedIndicator: '\x1B[36m▶\x1B[0m',
///   defaultIndicator: '\x1B[90m◆\x1B[0m',
/// );
/// ```
class Indicators {
  /// The indicator for the currently highlighted/selected item.
  /// Default is an orange filled circle.
  final String selectedIndicator;

  /// The indicator for non-selected items.
  /// Default is a purple empty circle.
  final String defaultIndicator;

  /// The indicator for items that have been confirmed/selected.
  /// Default is a green checkmark.
  final String confirmedIndicator;

  /// The indicator for items that are both currently selected and confirmed.
  /// Default is an orange checkmark.
  final String selectedConfirmedIndicator;

  /// Creates an [Indicators] instance with customizable selection symbols.
  ///
  /// All parameters are optional and have colored Unicode symbols as defaults.
  const Indicators({
    this.confirmedIndicator = '\x1B[32m☑\x1B[0m',
    this.defaultIndicator = '\x1B[35m○\x1B[0m',
    this.selectedConfirmedIndicator = '\x1B[38;5;214m☑\x1B[0m',
    this.selectedIndicator = '\x1B[38;5;214m●\x1B[0m',
  });
}
