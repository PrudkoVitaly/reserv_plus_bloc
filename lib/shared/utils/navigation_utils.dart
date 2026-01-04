import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:reserv_plus/features/shared/services/bottom_nav_bar_controller.dart';

/// Утилита для навигации с анимациями
/// Содержит переиспользуемые методы навигации с различными типами анимаций
class NavigationUtils {
  static const _bgColor = Color.fromRGBO(226, 223, 204, 1);

  /// Горизонтальная анимация перехода с полным слайдом
  /// Используется для основных переходов между экранами
  /// Автоматически скрывает BottomNavigationBar при переходе
  /// Анимирует оба экрана: уходящий влево, входящий справа (и наоборот при возврате)
  ///
  /// [context] - контекст виджета
  /// [page] - целевая страница для навигации
  /// [duration] - длительность анимации (по умолчанию 350ms)
  /// [fillColor] - цвет фона при переходе
  static Future<T?> pushWithHorizontalAnimation<T>({
    required BuildContext context,
    required Widget page,
    Duration duration = const Duration(milliseconds: 300),
    Color fillColor = _bgColor,
  }) {
    // Скрываем BottomNavigationBar
    BottomNavBarController().hide();

    return Navigator.of(context).push<T>(
      PageRouteBuilder<T>(
        opaque: false,
        barrierColor: fillColor,
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Анимация для входящего экрана (справа налево при push, слева направо при pop)
          final slideIn = Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          ));

          // Анимация для уходящего экрана (влево при push, возврат справа при pop)
          final slideOut = Tween<Offset>(
            begin: Offset.zero,
            end: const Offset(-0.3, 0.0),
          ).animate(CurvedAnimation(
            parent: secondaryAnimation,
            curve: Curves.easeInOut,
          ));

          // Затемнение уходящего экрана
          final fadeOut = Tween<double>(
            begin: 1.0,
            end: 0.5,
          ).animate(CurvedAnimation(
            parent: secondaryAnimation,
            curve: Curves.easeInOut,
          ));

          return SlideTransition(
            position: slideOut,
            child: FadeTransition(
              opacity: fadeOut,
              child: SlideTransition(
                position: slideIn,
                child: child,
              ),
            ),
          );
        },
        transitionDuration: duration,
        reverseTransitionDuration: duration,
      ),
    ).then((result) {
      // Показываем BottomNavigationBar при возврате
      BottomNavBarController().show();
      return result;
    });
  }

  /// Вертикальная анимация перехода (Shared Axis Vertical)
  /// Используется для модальных окон и вспомогательных экранов
  ///
  /// [context] - контекст виджета
  /// [page] - целевая страница для навигации
  /// [duration] - длительность анимации (по умолчанию 350ms)
  /// [fillColor] - цвет фона при переходе
  static Future<T?> pushWithVerticalAnimation<T>({
    required BuildContext context,
    required Widget page,
    Duration duration = const Duration(milliseconds: 350),
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
  /// [duration] - длительность анимации (по умолчанию 350ms)
  /// [fillColor] - цвет фона при переходе
  static Future<T?> pushWithScaledAnimation<T>({
    required BuildContext context,
    required Widget page,
    Duration duration = const Duration(milliseconds: 350),
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
  /// [duration] - длительность анимации (по умолчанию 350ms)
  static Future<T?> pushWithFadeAnimation<T>({
    required BuildContext context,
    required Widget page,
    Duration duration = const Duration(milliseconds: 350),
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
