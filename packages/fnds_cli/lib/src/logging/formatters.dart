import 'dart:io';

import 'logger.dart';

/// A collection of log formatters for CLI applications.
///
/// These formatters can be used to customize the output of the logger.

/// A formatter that adds color to log entries based on their level.
class ColoredLogFormatter implements LogFormatter {
  /// Creates a new [ColoredLogFormatter].
  const ColoredLogFormatter();

  @override
  String format(LogEntry entry) {
    final levelStr = entry.level.toString().split('.').last.toUpperCase();
    final timestamp = _formatTimestamp(entry.timestamp);
    final levelColor = _getLevelColor(entry.level);

    return '[$timestamp] ${_colorize(levelStr, levelColor)}: ${entry.message}';
  }

  String _colorize(String text, String color) {
    // Only use colors if output is to a terminal
    if (stdout.hasTerminal) {
      return '$color$text\x1B[0m';
    }
    return text;
  }

  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:'
        '${timestamp.minute.toString().padLeft(2, '0')}:'
        '${timestamp.second.toString().padLeft(2, '0')}';
  }

  String _getLevelColor(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return '\x1B[36m'; // Cyan
      case LogLevel.info:
        return '\x1B[32m'; // Green
      case LogLevel.warning:
        return '\x1B[33m'; // Yellow
      case LogLevel.error:
        return '\x1B[31m'; // Red
      default:
        return '\x1B[0m'; // Reset
    }
  }
}

/// A formatter that includes the source location in log entries.
class DetailedLogFormatter implements LogFormatter {
  /// Creates a new [DetailedLogFormatter].
  const DetailedLogFormatter();

  @override
  String format(LogEntry entry) {
    final levelStr = entry.level.toString().split('.').last.toUpperCase();
    final timestamp = _formatTimestamp(entry.timestamp);
    final date = _formatDate(entry.timestamp);

    return '[$date $timestamp] [$levelStr] ${entry.message}';
  }

  String _formatDate(DateTime timestamp) {
    return '${timestamp.year}-'
        '${timestamp.month.toString().padLeft(2, '0')}-'
        '${timestamp.day.toString().padLeft(2, '0')}';
  }

  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:'
        '${timestamp.minute.toString().padLeft(2, '0')}:'
        '${timestamp.second.toString().padLeft(2, '0')}.'
        '${(timestamp.millisecond ~/ 10).toString().padLeft(2, '0')}';
  }
}

/// A formatter that outputs log entries in JSON format.
class JsonLogFormatter implements LogFormatter {
  /// Creates a new [JsonLogFormatter].
  const JsonLogFormatter();

  @override
  String format(LogEntry entry) {
    final levelStr = entry.level.toString().split('.').last.toLowerCase();
    final timestamp = entry.timestamp.toIso8601String();

    return '{"timestamp":"$timestamp","level":"$levelStr","message":"${_escapeJson(entry.message)}"}';
  }

  String _escapeJson(String text) {
    return text
        .replaceAll('\\', '\\\\')
        .replaceAll('"', '\\"')
        .replaceAll('\n', '\\n')
        .replaceAll('\r', '\\r')
        .replaceAll('\t', '\\t');
  }
}

/// A formatter that can be customized with a pattern.
///
/// The pattern can include the following placeholders:
/// - {level}: The log level.
/// - {message}: The log message.
/// - {time}: The timestamp in HH:MM:SS format.
/// - {date}: The date in YYYY-MM-DD format.
class PatternLogFormatter implements LogFormatter {
  /// The pattern to use for formatting log entries.
  final String pattern;

  /// Creates a new [PatternLogFormatter] with the given pattern.
  ///
  /// The default pattern is `[{time}] {level}: {message}`.
  const PatternLogFormatter([this.pattern = '[{time}] {level}: {message}']);

  @override
  String format(LogEntry entry) {
    final levelStr = entry.level.toString().split('.').last.toUpperCase();
    final timestamp = _formatTimestamp(entry.timestamp);
    final date = _formatDate(entry.timestamp);

    return pattern
        .replaceAll('{level}', levelStr)
        .replaceAll('{message}', entry.message)
        .replaceAll('{time}', timestamp)
        .replaceAll('{date}', date);
  }

  String _formatDate(DateTime timestamp) {
    return '${timestamp.year}-'
        '${timestamp.month.toString().padLeft(2, '0')}-'
        '${timestamp.day.toString().padLeft(2, '0')}';
  }

  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:'
        '${timestamp.minute.toString().padLeft(2, '0')}:'
        '${timestamp.second.toString().padLeft(2, '0')}';
  }
}
