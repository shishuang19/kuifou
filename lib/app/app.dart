import 'package:flutter/material.dart';

import 'router.dart';
import 'theme/app_theme.dart';

class KuifouApp extends StatelessWidget {
  const KuifouApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '亏否',
      theme: AppTheme.darkTheme,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
