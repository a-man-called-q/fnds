import 'package:drift/drift.dart';

class Logs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get level => text()();
  TextColumn get message => text()();
  TextColumn get stacktrace => text().nullable()();
  TextColumn get tag => text().withDefault(const Constant('general'))();
  DateTimeColumn get timestamp => dateTime().withDefault(currentDateAndTime)();
}
