// core/router/page_transitions.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Slide ຈາກຂວາໄປຊ້າຍ - ໃຊ້ສຳລັບ "ໄປໜ້າໃໝ່" (push ລົງເລິກ)
CustomTransitionPage<T> slideTransitionPage<T>({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      final tween = Tween(begin: begin, end: end).chain(
        CurveTween(curve: Curves.easeOutCubic),
      );
      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );
}

/// Fade + scale ນ້ອຍໆ - ໃຊ້ສຳລັບປ່ຽນ "ລະດັບດຽວກັນ" ເຊັ່ນ Login ⇄ Register
CustomTransitionPage<void> fadeTransitionPage({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 250),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: ScaleTransition(
          scale: Tween(begin: 0.98, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOut),
          ),
          child: child,
        ),
      );
    },
  );
}

/// Fade ຢ່າງດຽວ - ໃຊ້ຕອນ login ສຳເລັດ ໄປ Home (ຄວາມຮູ້ສຶກ "ເລີ່ມໃໝ່" ບໍ່ແມ່ນ "push")
CustomTransitionPage<void> fadeThroughPage({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 400),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeIn),
        child: child,
      );
    },
  );
}