import 'package:drift/drift.dart';
import 'package:drift/native.dart';

LazyDatabase openConnection() {
  return LazyDatabase(() async => NativeDatabase.memory(logStatements: false));
}
