import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';

import 'database.dart';

class FNDSLogger {
  static final FNDSLogger _instance = FNDSLogger._internal();
  final LoggerDB _db = LoggerDB();
  final Duration retention = const Duration(days: 7);

  factory FNDSLogger() => _instance;

  FNDSLogger._internal();

  Future<void> clearLogs() async {
    await _db.delete(_db.logs).go();
  }

  Future<void> error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stacktrace,
  }) => log(
    '$message${error != null ? '\n$error' : ''}',
    tag: tag ?? 'general',
    level: 'ERROR',
  );

  Future<File> exportLogsToFile(String filePath) async {
    final logs = await _db.select(_db.logs).get();
    final buffer = StringBuffer();
    for (final log in logs) {
      buffer.writeln(
        '[${log.timestamp.toIso8601String()}] '
        '${log.level.padRight(7)} | ${log.tag} | ${log.message}',
      );
      if (log.stacktrace != null) {
        buffer.writeln('  Stacktrace: ${log.stacktrace}');
      }
      buffer.writeln('');
    }
    final file = File(filePath);
    return file.writeAsString(buffer.toString());
  }

  Future<List<Log>> getLogs({int limit = 100}) async {
    return await (_db.select(_db.logs)
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.timestamp, mode: OrderingMode.desc),
          ])
          ..limit(limit))
        .get();
  }

  Future<void> info(String message, {String? tag}) =>
      log(message, tag: tag ?? 'general', level: 'INFO');

  Future<void> log(
    String message, {
    String tag = 'general',
    String level = 'INFO',
  }) async {
    await _db
        .into(_db.logs)
        .insert(
          LogsCompanion(
            message: Value(message),
            tag: Value(tag),
            level: Value(level),
          ),
        );
    await _cleanup();
  }

  Future<Future<List<Log>>> queryLogs({
    String? level,
    String? tag,
    DateTime? since,
    DateTime? until,
  }) async {
    final query = _db.select(_db.logs);
    if (level != null) query.where((tbl) => tbl.level.equals(level));
    if (tag != null) query.where((tbl) => tbl.tag.equals(tag));
    if (since != null) {
      query.where((tbl) => tbl.timestamp.isBiggerOrEqualValue(since));
    }
    if (until != null) {
      query.where((tbl) => tbl.timestamp.isSmallerOrEqualValue(until));
    }
    return query.get();
  }

  Future<void> uploadLogs(Uri endpoint) async {
    final logs = await _db.select(_db.logs).get();
    final payload =
        logs
            .map(
              (log) => {
                'timestamp': log.timestamp.toIso8601String(),
                'level': log.level,
                'message': log.message,
                'tag': log.tag,
                'stacktrace': log.stacktrace,
              },
            )
            .toList();

    final httpClient = HttpClient();
    final request = await httpClient.postUrl(endpoint);
    request.headers.set('Content-Type', 'application/json');
    request.add(utf8.encode(jsonEncode(payload)));
    final response = await request.close();

    if (response.statusCode != 200) {
      throw Exception('Log upload failed: ${response.statusCode}');
    }
  }

  Future<void> warning(String message, {String? tag}) =>
      log(message, tag: tag ?? 'general', level: 'WARNING');

  Future<void> _cleanup() async {
    final cutoff = DateTime.now().subtract(retention);
    await (_db.delete(_db.logs)
      ..where((l) => l.timestamp.isSmallerThanValue(cutoff))).go();
  }
}
