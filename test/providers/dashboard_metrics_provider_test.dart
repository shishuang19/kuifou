import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kuifou/features/home/domain/entities/asset.dart';
import 'package:kuifou/features/home/presentation/providers/asset_list_provider.dart';
import 'package:kuifou/features/home/presentation/providers/dashboard_metrics_provider.dart';

Asset _asset({
  required String id,
  required double purchasePrice,
  required DateTime purchaseDate,
}) {
  return Asset(
    id: id,
    name: 'Asset-$id',
    categoryId: 'cat-default',
    icon: '📦',
    purchasePrice: purchasePrice,
    purchaseDate: purchaseDate,
    createdAt: DateTime(2026, 1, 1),
    updatedAt: DateTime(2026, 1, 1),
  );
}

void main() {
  group('dashboardMetricsProvider', () {
    test('returns zero metrics when asset list is empty', () async {
      final container = ProviderContainer(
        overrides: [
          assetListProvider.overrideWith((ref) async => []),
        ],
      );
      addTearDown(container.dispose);

      final metrics = await container.read(dashboardMetricsProvider.future);

      expect(metrics.assetCount, 0);
      expect(metrics.totalResidualValue, 0);
      expect(metrics.todayCost, 0);
      expect(metrics.estimatedDailyCost, 0);
    });

    test('computes metrics from asset list', () async {
      final assets = [
        _asset(
          id: 'a1',
          purchasePrice: 1200,
          purchaseDate: DateTime.now().subtract(const Duration(days: 12)),
        ),
        _asset(
          id: 'a2',
          purchasePrice: 600,
          purchaseDate: DateTime.now().subtract(const Duration(days: 6)),
        ),
      ];

      final expectedResidual = assets.fold<double>(
        0,
        (sum, asset) => sum + asset.residualValue,
      );
      final expectedDailyCost = assets.fold<double>(
        0,
        (sum, asset) => sum + asset.dailyCost,
      );

      final container = ProviderContainer(
        overrides: [
          assetListProvider.overrideWith((ref) async => assets),
        ],
      );
      addTearDown(container.dispose);

      final metrics = await container.read(dashboardMetricsProvider.future);

      expect(metrics.assetCount, assets.length);
      expect(metrics.totalResidualValue, expectedResidual);
      expect(metrics.todayCost, expectedDailyCost);
      expect(metrics.estimatedDailyCost, expectedDailyCost);
    });
  });
}
