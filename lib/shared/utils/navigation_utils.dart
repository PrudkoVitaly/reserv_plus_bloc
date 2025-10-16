import 'package:flutter/material.dart';
import 'package:animations/animations.dart';

/// Утилита для навигации с анимациями
/// Содержит переиспользуемые методы навигации с различными типами анимаций
class NavigationUtils {
  /// Горизонтальная анимация перехода (Shared Axis Horizontal)
  /// Используется для основных переходов между экранами
  ///
  /// [context] - контекст виджета
  /// [page] - целевая страница для навигации
  /// [duration] - длительность анимации (по умолчанию 900ms)
  /// [fillColor] - цвет фона при переходе
  static Future<T?> pushWithHorizontalAnimation<T>({
    required BuildContext context,
    required Widget page,
    Duration duration = const Duration(milliseconds: 900),
    Color fillColor = const Color.fromRGBO(226, 223, 204, 1),
  }) {
    return Navigator.of(context).push<T>(
      PageRouteBuilder<T>(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SharedAxisTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.horizontal,
            fillColor: fillColor,
            child: child,
          );
        },
        transitionDuration: duration,
        reverseTransitionDuration: duration,
      ),
    );
  }

  /// Вертикальная анимация перехода (Shared Axis Vertical)
  /// Используется для модальных окон и вспомогательных экранов
  ///
  /// [context] - контекст виджета
  /// [page] - целевая страница для навигации
  /// [duration] - длительность анимации (по умолчанию 900ms)
  /// [fillColor] - цвет фона при переходе
  static Future<T?> pushWithVerticalAnimation<T>({
    required BuildContext context,
    required Widget page,
    Duration duration = const Duration(milliseconds: 900),
    Color fillColor = const Color.fromRGBO(226, 223, 204, 1),
  }) {
    return Navigator.of(context).push<T>(
      PageRouteBuilder<T>(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SharedAxisTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.vertical,
            fillColor: fillColor,
            child: child,
          );
        },
        transitionDuration: duration,
        reverseTransitionDuration: duration,
      ),
    );
  }

  /// Анимация масштабирования (Shared Axis Scaled)
  /// Используется для переходов с эффектом увеличения/уменьшения
  ///
  /// [context] - контекст виджета
  /// [page] - целевая страница для навигации
  /// [duration] - длительность анимации (по умолчанию 900ms)
  /// [fillColor] - цвет фона при переходе
  static Future<T?> pushWithScaledAnimation<T>({
    required BuildContext context,
    required Widget page,
    Duration duration = const Duration(milliseconds: 900),
    Color fillColor = const Color.fromRGBO(226, 223, 204, 1),
  }) {
    return Navigator.of(context).push<T>(
      PageRouteBuilder<T>(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SharedAxisTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.scaled,
            fillColor: fillColor,
            child: child,
          );
        },
        transitionDuration: duration,
        reverseTransitionDuration: duration,
      ),
    );
  }

  /// Fade анимация перехода
  /// Используется для плавных переходов без направления
  ///
  /// [context] - контекст виджета
  /// [page] - целевая страница для навигации
  /// [duration] - длительность анимации (по умолчанию 900ms)
  static Future<T?> pushWithFadeAnimation<T>({
    required BuildContext context,
    required Widget page,
    Duration duration = const Duration(milliseconds: 900),
  }) {
    return Navigator.of(context).push<T>(
      PageRouteBuilder<T>(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: duration,
        reverseTransitionDuration: duration,
      ),
    );
  }

  /// Возврат на главный экран (первый экран в стеке)
  /// Удаляет все промежуточные экраны
  ///
  /// [context] - контекст виджета
  static void popToFirst(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  /// Стандартный возврат на предыдущий экран
  /// С автоматической обратной анимацией
  ///
  /// [context] - контекст виджета
  /// [result] - результат для передачи на предыдущий экран
  static void pop<T>(BuildContext context, [T? result]) {
    Navigator.of(context).pop(result);
  }
}
