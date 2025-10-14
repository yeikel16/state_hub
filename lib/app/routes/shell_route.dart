import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:state_hub/app/routes/app_routes.dart';

class HomeShellScaffold extends StatelessWidget {
  const HomeShellScaffold({
    required this.child,
    super.key,
  });

  final Widget child;

  int _getCurrentIndex(String location) {
    switch (location) {
      case '/':
        return 0;
      case '/favorites':
        return 1;
      case '/settings':
        return 2;
      default:
        return 0;
    }
  }

  void _onTabChanged(BuildContext context, int index) {
    switch (index) {
      case 0:
        const HomeRoute().go(context);
      case 1:
        const FavoritePropertiesRoute().go(context);
      case 2:
        const SettingsRoute().go(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final location = GoRouterState.of(context).uri.path;
    final currentIndex = _getCurrentIndex(location);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) => _onTabChanged(context, index),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.house_outlined),
            selectedIcon: Icon(
              Icons.house_rounded,
              color: theme.colorScheme.primary,
            ),
            label: 'Home',
          ),
          NavigationDestination(
            icon: const Icon(Icons.favorite_border),
            selectedIcon: Icon(
              Icons.favorite,
              color: theme.colorScheme.primary,
            ),
            label: 'Favorites',
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings),
            selectedIcon: Icon(
              Icons.settings,
              color: theme.colorScheme.primary,
            ),
            label: 'Settings',
          ),
        ],
      ),
      body: child,
    );
  }
}
