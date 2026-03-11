import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

/// Native 平台数据库连接实现
QueryExecutor createDatabaseConnection({bool inMemory = false}) {
  if (inMemory || Platform.environment.containsKey('FLUTTER_TEST')) {
    return NativeDatabase.memory();
  }

  return LazyDatabase(() async {
    try {
      final dbDirectory = await getApplicationSupportDirectory();
      if (!await dbDirectory.exists()) {
        await dbDirectory.create(recursive: true);
      }

      final dbFile = File('${dbDirectory.path}/kuifou.sqlite');
      return NativeDatabase.createInBackground(dbFile);
    } on MissingPluginException {
      // Widget tests may run without path_provider plugin registration.
      return NativeDatabase.memory();
    } on FileSystemException {
      return NativeDatabase.memory();
    }
  });
}
