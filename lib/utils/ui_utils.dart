import 'package:flutter/material.dart';

class AppUIUtils {
  static Route<T> fadeTransitionBuilder<T>(
    Widget child, {
    RouteSettings? settings,
  }) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  static Future<T?> showMyModalBottomSheet<T>(
    BuildContext context,
    Widget Function(BuildContext) builder, {
    bool useRootNavigator = false,
  }) =>
      showModalBottomSheet<T>(
        isScrollControlled: true,
        enableDrag: true,
        useRootNavigator: useRootNavigator,
        backgroundColor: Colors.transparent,
        context: context,
        builder: builder,
      );
}
