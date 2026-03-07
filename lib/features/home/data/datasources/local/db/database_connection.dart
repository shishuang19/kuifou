import 'package:drift/drift.dart';
import 'database_connection_stub.dart'
    if (dart.library.io) 'database_connection_native.dart'
    if (dart.library.html) 'database_connection_web.dart';

/// 获取数据库连接（跨平台）
QueryExecutor getDatabaseConnection({bool inMemory = false}) {
  return createDatabaseConnection(inMemory: inMemory);
}
