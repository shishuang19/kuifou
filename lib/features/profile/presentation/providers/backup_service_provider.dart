import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../home/presentation/providers/asset_list_provider.dart';
import '../../../home/presentation/providers/category_list_provider.dart';
import '../../data/services/backup_service.dart';

final backupServiceProvider = Provider<BackupService>((ref) {
  return BackupService(
    assetRepository: ref.watch(assetRepositoryProvider),
    categoryRepository: ref.watch(categoryRepositoryProvider),
  );
});
