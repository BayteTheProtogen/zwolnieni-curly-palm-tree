import 'package:flutter/material.dart';

class MagicMoveRoute extends PageRouteBuilder {
  final Widget page;

  MagicMoveRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 600),
        );
}
