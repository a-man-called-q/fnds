part of 'core.dart';

/// Thrown when argument parsing fails and interactive fallback is not enabled or also fails.
class ArgumentParsingException extends CliException {
  final String commandName;
  final Object originalException;
  ArgumentParsingException(this.commandName, this.originalException)
    : super(
        'Failed to parse arguments for command "$commandName".\nOriginal error: $originalException',
      );
}

/// Base class for framework-specific exceptions.
class CliException implements Exception {
  final String message;
  CliException(this.message);

  @override
  String toString() => message;
}

/// Thrown when an error occurs during command execution.
class CommandExecutionException extends CliException {
  final String commandName;
  final Object originalException;
  final StackTrace? originalStackTrace;

  CommandExecutionException(
    this.commandName,
    this.originalException, [
    this.originalStackTrace,
  ]) : super('Error executing command "$commandName": $originalException');
}

/// Thrown when a command or subcommand is not found.
class CommandNotFoundException extends CliException {
  final List<String> commandPath;
  CommandNotFoundException(this.commandPath)
    : super('Command not found: "${commandPath.join(' ')}"');
}
