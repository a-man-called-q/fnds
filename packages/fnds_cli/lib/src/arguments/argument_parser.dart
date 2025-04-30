/// Interface for argument parsers in the CLI framework.
///
/// This abstraction allows different argument parsing libraries to be used,
/// with 'args' being the default implementation.
abstract class ArgumentParser<T> {
  /// Returns a usage string for the arguments.
  String get usage;

  /// Adds a command-line flag that can be either present or not.
  void addFlag(
    String name, {
    String? abbr,
    String? help,
    bool defaultsTo = false,
    bool negatable = true,
    bool hide = false,
  });

  /// Adds a command-line option that can occur multiple times.
  void addMultiOption(
    String name, {
    String? abbr,
    String? help,
    List<String>? defaultsTo,
    bool mandatory = false,
    List<String>? allowed,
    Map<String, String>? allowedHelp,
    String? valueHelp,
    bool hide = false,
  });

  /// Adds a command-line option that takes a single value.
  void addOption(
    String name, {
    String? abbr,
    String? help,
    String? defaultsTo,
    bool mandatory = false,
    List<String>? allowed,
    Map<String, String>? allowedHelp,
    String? valueHelp,
    bool hide = false,
  });

  /// Parses the given command-line arguments.
  ///
  /// Returns a result object that can be used to access the parsed values.
  T parse(List<String> args);
}
