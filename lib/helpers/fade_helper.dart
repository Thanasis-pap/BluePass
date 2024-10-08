import 'package:flutter/material.dart';

// Custom PageRoute with Fade and Slide Left Transition
class LeftPageRoute extends PageRouteBuilder {
  final Widget page;


  LeftPageRoute({required this.page})
      : super(
    transitionDuration: Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0); // Start from the right side
      const end = Offset.zero; // End at the center
      const curve = Curves.easeInOut;

      final tween = Tween(begin: begin, end: end).chain(
        CurveTween(curve: curve),
      );

      final fadeTween = Tween<double>(begin: 0.0, end: 1.0).chain(
        CurveTween(curve: curve),
      );

      return SlideTransition(
        position: animation.drive(tween),
        child: FadeTransition(
          opacity: animation.drive(fadeTween),
          child: child,
        ),
      );
    },
  );
}
