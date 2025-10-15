// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$homeShellRoute];

RouteBase get $homeShellRoute => ShellRouteData.$route(
  factory: $HomeShellRouteExtension._fromState,
  routes: [
    GoRouteData.$route(
      path: '/home',
      factory: $HomeRoute._fromState,
      routes: [
        GoRouteData.$route(
          path: 'details',
          parentNavigatorKey: PropertyDetailsRoute.$parentNavigatorKey,
          factory: $PropertyDetailsRoute._fromState,
        ),
      ],
    ),
    GoRouteData.$route(
      path: '/favorites',
      factory: $FavoritePropertiesRoute._fromState,
    ),
    GoRouteData.$route(path: '/settings', factory: $SettingsRoute._fromState),
  ],
);

extension $HomeShellRouteExtension on HomeShellRoute {
  static HomeShellRoute _fromState(GoRouterState state) => HomeShellRoute();
}

mixin $HomeRoute on GoRouteData {
  static HomeRoute _fromState(GoRouterState state) => const HomeRoute();

  @override
  String get location => GoRouteData.$location('/home');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $PropertyDetailsRoute on GoRouteData {
  static PropertyDetailsRoute _fromState(GoRouterState state) =>
      PropertyDetailsRoute($extra: state.extra as PropertyModel?);

  PropertyDetailsRoute get _self => this as PropertyDetailsRoute;

  @override
  String get location => GoRouteData.$location('/home/details');

  @override
  void go(BuildContext context) => context.go(location, extra: _self.$extra);

  @override
  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: _self.$extra);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: _self.$extra);

  @override
  void replace(BuildContext context) =>
      context.replace(location, extra: _self.$extra);
}

mixin $FavoritePropertiesRoute on GoRouteData {
  static FavoritePropertiesRoute _fromState(GoRouterState state) =>
      const FavoritePropertiesRoute();

  @override
  String get location => GoRouteData.$location('/favorites');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $SettingsRoute on GoRouteData {
  static SettingsRoute _fromState(GoRouterState state) => const SettingsRoute();

  @override
  String get location => GoRouteData.$location('/settings');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
