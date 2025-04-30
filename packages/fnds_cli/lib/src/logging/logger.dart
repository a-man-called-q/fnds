/// The default formatter for log entries.
class DefaultLogFormatter implements LogFormatter {
  /// Creates a new [DefaultLogFormatter].
  const DefaultLogFormatter();

  @override
  String format(LogEntry entry) {
    final levelStr = entry.level.toString().split('.').last.toUpperCase();
    final timestamp = _formatTimestamp(entry.timestamp);
    return '[$timestamp] $levelStr: ${entry.message}';
  }

  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:'
        '${timestamp.minute.toString().padLeft(2, '0')}:'
        '${timestamp.second.toString().padLeft(2, '0')}';
  }
}

/// A log entry in the CLI framework.
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
abstract class LogFormatter {
  /// Formats a log entry for output.
  String format(LogEntry entry);
}

/// A logger for CLI applications.
class Logger {
  /// The current log level.
  ///
  /// Messages below this level will not be logged.
  LogLevel level;

  LogFormatter _formatter;

  /// Creates a new [Logger] with the given formatter and level.
  Logger({LogFormatter? formatter, this.level = LogLevel.info})
    : _formatter = formatter ?? const DefaultLogFormatter();

  /// The formatter to use for log entries.
  LogFormatter get formatter => _formatter;

  /// Sets a new formatter for this logger.
  set formatter(LogFormatter formatter) {
    _formatter = formatter;
  }

  /// Logs a debug message.
  void debug(String message) {
    _log(message, LogLevel.debug);
  }

  /// Logs an error message.
  void error(String message) {
    _log(message, LogLevel.error);
  }

  /// Logs an info message.
  void info(String message) {
    _log(message, LogLevel.info);
  }

  /// Logs a warning message.
  void warning(String message) {
    _log(message, LogLevel.warning);
  }

  /// Logs a message at the given level.
  void _log(String message, LogLevel messageLevel) {
    if (messageLevel.index < level.index) {
      return;
    }

    final entry = LogEntry(
      message: message,
      level: messageLevel,
      timestamp: DateTime.now(),
    );

    print(_formatter.format(entry));
  }
}

/// Log levels for the CLI framework.
enum LogLevel {
  /// Debug level for detailed diagnostic information.
  debug,

  /// Info level for general information about application progress.
  info,

  /// Warning level for potentially harmful situations.
  warning,

  /// Error level for error events that might still allow the application to continue.
  error,

  /// None level to disable logging.
  none,
}

/// A simple formatter that only includes the message.
class SimpleLogFormatter implements LogFormatter {
  /// Creates a new [SimpleLogFormatter].
  const SimpleLogFormatter();

  @override
  String format(LogEntry entry) {
    return entry.message;
  }
}
