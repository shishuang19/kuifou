// ignore_for_file: deprecated_member_use

import 'package:drift/drift.dart';
import 'package:drift/web.dart';

/// Web 平台数据库连接实现（使用纯 JS 实现，不依赖 WASM）
QueryExecutor createDatabaseConnection({bool inMemory = false}) {
  // 使用 WebDatabase 的默认实现（基于 IndexedDB + sql.js）
  // 注意：这个方案在某些环境可能需要额外配置
  // 如遇到问题，可考虑改用 WasmDatabase 或纯内存方案
  return WebDatabase('kuifou_db', logStatements: false);
}
