/// Base class for all errors in the CLI framework.
class CommandError implements Exception {
  /// The error message.
  final String message;

  /// The exit code to use when this error is thrown.
  ///
  /// By default, this is 1, which indicates a general error.
  final int exitCode;

  /// Creates a new [CommandError] with the given message and exit code.
  const CommandError(this.message, {this.exitCode = 1});

  @override
  String toString() => '${runtimeType.toString()}: $message';
}

/// Error thrown when a command fails due to a configuration issue.
class ConfigError extends CommandError {
  /// Creates a new [ConfigError] with the given message.
  const ConfigError(super.message) : super(exitCode: 78);
}

/// Error thrown when a command encounters an input/output error.
class IoError extends CommandError {
  /// Creates a new [IoError] with the given message.
  const IoError(super.message) : super(exitCode: 74);
}

/// Error thrown when a command is used incorrectly.
class UsageError extends CommandError {
  /// Creates a new [UsageError] with the given message.
  const UsageError(super.message) : super(exitCode: 64);
}
