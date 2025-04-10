// File: test/fnds_logger_test.dart

import 'package:fnds_logger/fnds_logger.dart';
import 'package:fnds_logger/src/database.dart';
import 'package:test/test.dart';

void main() {
  final logger = FNDSLogger();

  setUp(() async {
    await logger.clearLogs();
  });

  test('log info message', () async {
    await logger.info('This is an info log');
    final logs = await logger.getLogs();

    expect(logs.length, 1);
    expect(logs.first.message, 'This is an info log');
    expect(logs.first.level, 'INFO');
  });

  test('log warning message', () async {
    await logger.warning('This is a warning');
    final logs = await logger.getLogs();

    expect(logs.length, 1);
    expect(logs.first.level, 'WARNING');
  });

  test('log error message with error & stacktrace', () async {
    try {
      throw Exception('boom');
    } catch (e, st) {
      await logger.error('Caught an error', error: e, stacktrace: st);
    }
    final logs = await logger.getLogs();

    expect(logs.length, 1);
    expect(logs.first.level, 'ERROR');
    expect(logs.first.message.contains('Caught an error'), isTrue);
  });

  test('query logs by level', () async {
    await logger.info('info');
    await logger.warning('warn');

    final Future<List<Log>> infoLogs = await logger.queryLogs(level: 'INFO');
    expect((await infoLogs).length, 1);
    expect((await infoLogs).first.level, 'INFO');
  });

  test('clear logs', () async {
    await logger.info('Keep this log');
    var logs = await logger.getLogs();
    expect(logs, isNotEmpty);

    await logger.clearLogs();
    logs = await logger.getLogs();
    expect(logs, isEmpty);
  });
}
