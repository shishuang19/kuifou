import 'package:drift/drift.dart';
import 'package:drift/native.dart';

/// Native 平台数据库连接实现
QueryExecutor createDatabaseConnection({bool inMemory = false}) {
  if (inMemory) {
    return NativeDatabase.memory();
  }
  // V1 keeps an in-memory database; persistent storage will be added in a later milestone.
  return NativeDatabase.memory();
}
