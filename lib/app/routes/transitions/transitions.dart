import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// Custom slide transition for smooth navigation
CustomTransitionPage<T> buildPageWithSlideTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
  bool slideFromRight = true,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1, 0);
      const end = Offset.zero;
      const curve = Curves.easeInOutCubic;

      final tween = Tween(begin: slideFromRight ? begin : -begin, end: end);
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: curve,
      );

      return SlideTransition(
        position: tween.animate(curvedAnimation),
        child: child,
      );
    },
  );
}

/// Fade transition for smooth navigation
CustomTransitionPage<T> buildPageWithFadeTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 250),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}
