import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;

LazyDatabase openConnection() {
  return LazyDatabase(() async {
    final dbFile = File(p.join(Directory.current.path, 'fnds_logs.sqlite'));
    return NativeDatabase(dbFile);
  });
}
