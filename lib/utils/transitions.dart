import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

Route<T> fadeThroughRoute<T>(
    Widget page, {
      Duration duration = const Duration(milliseconds: 700),
    }) {
  return PageRouteBuilder<T>(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionDuration: duration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeThroughTransition(
        animation: animation,
        secondaryAnimation: secondaryAnimation,
        child: child,
      );
    },
  );
}

Route<T> fadeRoute<T>(
    Widget page, {
      Duration duration = const Duration(milliseconds: 300),
    }) {
  return PageRouteBuilder<T>(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionDuration: duration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeThroughTransition(
        animation: animation,
        secondaryAnimation: secondaryAnimation,
        child: child,
      );
    },
  );
}

Route<T> slideTransitionRoute<T>(Widget page, {Duration duration = const Duration(milliseconds: 300)}) {
  return PageRouteBuilder<T>(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      final offsetAnimation = animation.drive(tween);

      final exitTween = Tween(begin: Offset.zero, end: const Offset(-0.3, 0.0)).chain(CurveTween(curve: curve));
      final secondaryOffsetAnimation = secondaryAnimation.drive(exitTween);

      return SlideTransition(
        position: secondaryOffsetAnimation,
        child: SlideTransition(
          position: offsetAnimation,
          child: child,
        ),
      );
    },
    transitionDuration: duration,
  );
}

Route<T> scaleRoute<T>(Widget page, {Duration duration = const Duration(milliseconds: 400)}) {
  return PageRouteBuilder<T>(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return ScaleTransition(
        scale: animation,
        child: child,
      );
    },
    transitionDuration: duration,
  );
}
