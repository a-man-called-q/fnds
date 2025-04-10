import 'package:drift/drift.dart';

import 'setup/setup.dart';
import 'tables/logs.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Logs])
class LoggerDB extends _$LoggerDB {
  LoggerDB() : super(openConnection());

  @override
  int get schemaVersion => 1;
}
