import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UnanimatedPageRoute<T> extends MaterialPageRoute<T> {
  UnanimatedPageRoute({
    required Widget Function(BuildContext) builder,
    RouteSettings? settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) : super(
    builder: builder,
    settings: settings,
    maintainState: maintainState,
    fullscreenDialog: fullscreenDialog,
  );

  @override
  Widget buildTransitions(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
      ) {
    return child;
  }
}


CustomTransitionPage buildPageWithDefaultTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(opacity: animation, child: child),
  );
}

Page<dynamic> Function(BuildContext, GoRouterState) defaultPageBuilder<T>(
    Widget child) =>
        (BuildContext context, GoRouterState state) {
      return buildPageWithDefaultTransition<T>(
        context: context,
        state: state,
        child: child,
      );
    };


CustomTransitionPage<dynamic> customTransitionPage(GoRouterState state , Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity:
        CurveTween(curve: Curves.easeInOutCirc).animate(animation),
        child: child,
      );
    },
  );
}

