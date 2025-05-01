/// Data models for CLI state and layout specifications.
///
/// This file defines the core data models used throughout the FNDS CLI framework:
///
/// - [CLIState] - Base class for all state management within CLI applications
/// - [SingleCLIState] - Represents a single value from user input (like a text response)
/// - [GroupCLIState] - Represents multiple selected values (like from a checkbox list)
/// - [Width] - Base class for layout width specifications
/// - [AutoWidth] - For content that should automatically size to fit
/// - [IntWidth] - For content with fixed width requirements
///
/// These models work with the [StateManager] to provide a consistent way to
/// handle user inputs and layout calculations across the CLI framework.
part of 'utils.dart';

/// A width specification that automatically adjusts to content.
///
/// The [AutoWidth] class represents a flexible width that will automatically
/// adjust based on the content size. It's used in layout calculations for terminal output.
class AutoWidth extends Width {
  /// Creates an auto-adjusting width that adapts to content size.
  ///
  /// Use this constructor when you want a layout element to automatically
  /// size itself based on its content rather than having a fixed width.
  const AutoWidth();
}

/// Base class for CLI state management.
///
/// The [CLIState] class is the foundation for storing and managing state in CLI applications.
/// It provides a common base for different types of states (single values and groups of values)
/// and includes an optional label for identifying the state.
class CLIState {
  /// An optional identifier for the state.
  ///
  /// This label can be used to look up states by name rather than by index.
  final String? label;

  /// Creates a new CLI state with an optional label.
  const CLIState(this.label);
}

/// Represents a collection of selected values from a group of options.
///
/// The [GroupCLIState] class extends [CLIState] to store multiple selected options
/// from a set of choices, such as from a multiple selection interface.
///
/// Type parameter [T] defines the type of values stored in the collection.
class GroupCLIState<T> extends CLIState {
  /// The list of selected options or values.
  final List<T> selectedOptions;

  /// Creates a group state with a label and a list of selected options.
  const GroupCLIState(super.label, this.selectedOptions);
}

/// A width specification with a fixed integer value.
///
/// The [IntWidth] class represents a fixed width used in layout calculations
/// for terminal output.
class IntWidth extends Width {
  /// The fixed width value.
  final int value;

  /// Creates a fixed width with the specified value.
  const IntWidth(this.value);
}

/// Represents a single value state from a CLI interaction.
///
/// The [SingleCLIState] class extends [CLIState] to store a single value
/// of type [T], such as a string from a text prompt or a boolean from a confirmation.
///
/// Type parameter [T] defines the type of the stored value.
class SingleCLIState<T> extends CLIState {
  /// The stored value of type [T].
  final T value;

  /// Creates a single value state with a label and value.
  const SingleCLIState(super.label, this.value);
}

/// Base class for width specifications in layout calculations.
///
/// The [Width] class is a sealed class that serves as the base for
/// different types of width specifications used in rendering CLI interfaces.
sealed class Width {
  const Width();
}
