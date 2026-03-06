import 'package:go_router/go_router.dart';

import '../features/asset_form/asset_form_page.dart';
import '../features/home/home_page.dart';
import '../features/profile/profile_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: <GoRoute>[
    GoRoute(
      path: '/',
      builder: (_, __) => const HomePage(),
    ),
    GoRoute(
      path: '/add',
      builder: (_, __) => const AssetFormPage(),
    ),
    GoRoute(
      path: '/profile',
      builder: (_, __) => const ProfilePage(),
    ),
  ],
);
