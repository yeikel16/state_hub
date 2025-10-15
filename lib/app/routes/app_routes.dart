import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:state_hub/app/routes/shell_route.dart';
import 'package:state_hub/app/routes/transitions/transitions.dart';
import 'package:state_hub/app/routes/utils/not_found_page.dart';
import 'package:state_hub/src/data/models/models.dart';
import 'package:state_hub/src/features/favorites/favorites_page.dart';
import 'package:state_hub/src/features/home/home_page.dart';
import 'package:state_hub/src/features/property_details/property_details_page.dart';
import 'package:state_hub/src/features/settings/settings_page.dart';

part 'app_routes.g.dart';

final GlobalKey<NavigatorState> shellNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

final appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  observers: [],
  initialLocation: const HomeRoute().location,
  routes: $appRoutes,
  errorBuilder: (context, state) => const NotFoundPage(),
);

@TypedStatefulShellRoute<HomeShellRoute>(
  branches: [
    TypedStatefulShellBranch(
      routes: [
        TypedGoRoute<HomeRoute>(
          path: '/home',
          routes: [
            TypedGoRoute<PropertyDetailsRoute>(
              path: 'details',
            ),
          ],
        ),
      ],
    ),
    TypedStatefulShellBranch(
      routes: [
        TypedGoRoute<FavoritePropertiesRoute>(
          path: '/favorites',
          routes: [
            TypedGoRoute<FavoritePropertyDetailsRoute>(
              path: 'details',
            ),
          ],
        ),
      ],
    ),
    TypedStatefulShellBranch(
      routes: [
        TypedGoRoute<SettingsRoute>(
          path: '/settings',
        ),
      ],
    ),
  ],
)
class HomeShellRoute extends StatefulShellRouteData {
  HomeShellRoute();

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    return HomeShellScaffold(child: navigationShell);
  }
}

class HomeRoute extends GoRouteData with $HomeRoute {
  const HomeRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return buildPageWithFadeTransition(
      context: context,
      state: state,
      child: const HomePage(),
    );
  }
}

class PropertyDetailsRoute extends GoRouteData with $PropertyDetailsRoute {
  const PropertyDetailsRoute({required this.$extra});

  final PropertyModel? $extra;

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return buildPageWithFadeTransition(
      context: context,
      state: state,
      child: PropertyDetailsPage(property: $extra),
    );
  }
}

class FavoritePropertyDetailsRoute extends GoRouteData
    with $FavoritePropertyDetailsRoute {
  const FavoritePropertyDetailsRoute({required this.$extra});

  final PropertyModel? $extra;

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return buildPageWithFadeTransition(
      context: context,
      state: state,
      child: PropertyDetailsPage(property: $extra),
    );
  }
}

class FavoritePropertiesRoute extends GoRouteData
    with $FavoritePropertiesRoute {
  const FavoritePropertiesRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return buildPageWithFadeTransition(
      context: context,
      state: state,
      child: const FavoritePropertiesPage(),
    );
  }
}

class SettingsRoute extends GoRouteData with $SettingsRoute {
  const SettingsRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return buildPageWithFadeTransition(
      context: context,
      state: state,
      child: const SettingsPage(),
    );
  }
}
