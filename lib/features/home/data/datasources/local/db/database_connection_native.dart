import 'package:drift/drift.dart';
import 'package:drift/native.dart';

/// Native 平台数据库连接实现
QueryExecutor createDatabaseConnection({bool inMemory = false}) {
  if (inMemory) {
    return NativeDatabase.memory();
  }
  // TODO: 添加持久化数据库支持
  return NativeDatabase.memory();
}
