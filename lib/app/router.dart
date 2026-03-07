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
      path: '/asset/new',
      builder: (_, __) => const AssetFormPage(),
    ),
    GoRoute(
      path: '/asset/:id/edit',
      builder: (_, state) {
        final assetId = state.pathParameters['id'];
        if (assetId == null || assetId.isEmpty) {
          return const AssetFormPage();
        }
        return AssetFormPage(assetId: assetId);
      },
    ),
    GoRoute(
      path: '/add',
      redirect: (_, __) => '/asset/new',
    ),
    GoRoute(
      path: '/profile',
      builder: (_, __) => const ProfilePage(),
    ),
  ],
);
