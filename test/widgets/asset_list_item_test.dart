import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

import 'package:kuifou/features/home/domain/entities/asset.dart';
import 'package:kuifou/features/home/presentation/widgets/asset_list_item.dart';

Asset _buildAsset({
  AssetStatus status = AssetStatus.idle,
}) {
  return Asset(
    id: 'asset-1',
    name: 'Test Camera',
    categoryId: 'cat-electronics',
    icon: '📷',
    purchasePrice: 3000,
    purchaseDate: DateTime.now().subtract(const Duration(days: 10)),
    status: status,
    createdAt: DateTime(2026, 1, 1),
    updatedAt: DateTime(2026, 1, 1),
  );
}

void main() {
  testWidgets('AssetListItem renders key asset info', (WidgetTester tester) async {
    final asset = _buildAsset();
    final numberFormat = NumberFormat.currency(
      locale: 'zh_CN',
      symbol: '¥',
      decimalDigits: 2,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AssetListItem(asset: asset),
        ),
      ),
    );

    expect(find.text('Test Camera'), findsOneWidget);
    expect(find.text('📷'), findsOneWidget);
    expect(find.text('闲置'), findsOneWidget);
    expect(find.textContaining('已用'), findsOneWidget);

    expect(find.text('购入价'), findsOneWidget);
    expect(find.text('每日成本'), findsOneWidget);
    expect(find.text('残值'), findsOneWidget);

    expect(find.text(numberFormat.format(asset.purchasePrice)), findsOneWidget);
    expect(find.text(numberFormat.format(asset.dailyCost)), findsOneWidget);
    expect(find.text(numberFormat.format(asset.residualValue)), findsOneWidget);
    expect(find.text('0%'), findsOneWidget);
  });

  testWidgets('AssetListItem calls onTap callback', (WidgetTester tester) async {
    final asset = _buildAsset();
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AssetListItem(
            asset: asset,
            onTap: () {
              tapped = true;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byType(InkWell));
    await tester.pumpAndSettle();

    expect(tapped, isTrue);
  });
}
