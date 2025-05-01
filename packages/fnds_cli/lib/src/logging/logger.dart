/// Flexible logging system for CLI applications.
///
/// This module provides a lightweight but powerful logging system that supports:
/// - Multiple log levels (debug, info, warning, error, none)
/// - Customizable log formatting through the [LogFormatter] interface
/// - Default implementations for common formatting needs
/// - Timestamp inclusion in log entries
///
/// The logging system allows CLI applications to provide appropriate feedback
/// based on verbosity settings and can be used throughout the application for
/// consistent message handling.
///
/// Example usage:
/// ```dart
/// final logger = Logger();
/// logger.info('Starting application...');
/// logger.debug('Debug information'); // Only shown when level is set to LogLevel.debug
/// logger.error('An error occurred');
/// ```
class DefaultLogFormatter implements LogFormatter {
  /// Creates a new [DefaultLogFormatter].
  const DefaultLogFormatter();

  @override
  String format(LogEntry entry) {
    final levelStr = entry.level.toString().split('.').last.toUpperCase();
    final timestamp = _formatTimestamp(entry.timestamp);
    return '[$timestamp] $levelStr: ${entry.message}';
  }

  /// Formats a timestamp into a human-readable string.
  ///
  /// The format used is HH:MM:SS in 24-hour format.
  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:'
        '${timestamp.minute.toString().padLeft(2, '0')}:'
        '${timestamp.second.toString().padLeft(2, '0')}';
  }
}

/// A log entry in the CLI framework.
///
/// This class represents a single log message with its associated metadata,
/// including the log level and timestamp.
class LogEntry {
  /// The message to log.
  final String message;

  /// The level of the log entry.
  final LogLevel level;

  /// The timestamp of the log entry.
  final DateTime timestamp;

  /// Creates a new [LogEntry] with the given message and level.
  const LogEntry({
    required this.message,
    required this.level,
    required this.timestamp,
  });
}

/// A formatter for log entries.
///
/// This interface can be implemented to create custom log formatting,
/// allowing applications to control how logs are formatted for output.
abstract class LogFormatter {
  /// Formats a log entry for output.
  ///
  /// Implementations should convert the [LogEntry] into a formatted string
  /// that can be displayed to the user.
  String format(LogEntry entry);
}

/// A logger for CLI applications.
///
/// This class provides the core logging functionality for the CLI framework,
/// supporting multiple log levels and customizable formatting.
class Logger {
  /// The current log level.
  ///
  /// Messages below this level will not be logged.
  LogLevel level;

  /// The formatter used to format log entries.
  ///
  /// By default, this is a [DefaultLogFormatter], but it can be replaced
  /// with any implementation of [LogFormatter].
  LogFormatter formatter;

  /// Creates a new [Logger] with the given formatter and level.
  ///
  /// If no formatter is provided, a [DefaultLogFormatter] will be used.
  /// The default log level is [LogLevel.info].
  Logger({LogFormatter? formatter, this.level = LogLevel.info})
    : formatter = formatter ?? const DefaultLogFormatter();

  /// Logs a debug message.
  ///
  /// Debug messages are typically used for detailed information that is
  /// helpful during development or troubleshooting.
  void debug(String message) {
    _log(message, LogLevel.debug);
  }

  /// Logs an error message.
  ///
  /// Error messages indicate that something has gone wrong and should
  /// be investigated.
  void error(String message) {
    _log(message, LogLevel.error);
  }

  /// Logs an info message.
  ///
  /// Info messages provide general information about the application's
  /// operation that might be useful to users.
  void info(String message) {
    _log(message, LogLevel.info);
  }

  /// Logs a warning message.
  ///
  /// Warning messages indicate potential issues that might need attention
  /// but don't prevent the application from functioning.
  void warning(String message) {
    _log(message, LogLevel.warning);
  }

  /// Logs a message at the given level.
  ///
  /// This internal method handles the actual logging logic, checking the
  /// current log level and formatting the log entry before output.
  void _log(String message, LogLevel messageLevel) {
    if (messageLevel.index < level.index) {
      return;
    }

    final entry = LogEntry(
      message: message,
      level: messageLevel,
      timestamp: DateTime.now(),
    );

    print(formatter.format(entry));
  }
}

/// Log levels for the CLI framework.
///
/// The log levels are ordered from most verbose ([debug]) to least verbose ([none]),
/// allowing applications to control the amount of logging output.
enum LogLevel {
  /// Debug level for detailed diagnostic information.
  ///
  /// This level is typically used during development or when troubleshooting
  /// issues in production.
  debug,

  /// Info level for general information about application progress.
  ///
  /// This is the default log level and provides a good balance of information
  /// without overwhelming the user.
  info,

  /// Warning level for potentially harmful situations.
  ///
  /// Warnings indicate issues that don't prevent the application from working
  /// but might require attention.
  warning,

  /// Error level for error events that might still allow the application to continue.
  ///
  /// Errors indicate that something has gone wrong and should be investigated.
  error,

  /// None level to disable logging.
  ///
  /// This level can be used to completely disable logging output.
  none,
}

/// A simple formatter that only includes the message.
///
/// This formatter produces minimal output by excluding timestamps and log levels,
/// which can be useful for specific use cases where that information is not needed.
class SimpleLogFormatter implements LogFormatter {
  /// Creates a new [SimpleLogFormatter].
  const SimpleLogFormatter();

  @override
  String format(LogEntry entry) {
    return entry.message;
  }
}
