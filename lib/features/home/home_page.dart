import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/spacing.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('亏否')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('首页'),
            const SizedBox(height: AppSpacing.lg),
            FilledButton(
              onPressed: () => context.go('/add'),
              child: const Text('添加物品'),
            ),
            const SizedBox(height: AppSpacing.md),
            OutlinedButton(
              onPressed: () => context.go('/profile'),
              child: const Text('个人中心'),
            ),
          ],
        ),
      ),
    );
  }
}
