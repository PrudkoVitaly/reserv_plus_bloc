import 'package:flutter/material.dart';

/// Утилита для показа анимированного bottom sheet, который выезжает снизу
class DraggableBottomSheet {
  /// Показать bottom sheet с кастомным содержимым
  ///
  /// [context] - BuildContext
  /// [title] - Заголовок (может быть многострочным)
  /// [child] - Содержимое под заголовком
  /// [initialChildSize] - Начальный размер (0.0 - 1.0), по умолчанию 0.93
  /// [minChildSize] - Минимальный размер при сворачивании, по умолчанию 0.5
  /// [maxChildSize] - Максимальный размер, по умолчанию 0.95
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required Widget child,
    double initialChildSize = 0.95,
    double minChildSize = 0.5,
    double maxChildSize = 0.95,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: initialChildSize,
        minChildSize: minChildSize,
        maxChildSize: maxChildSize,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Color.fromRGBO(226, 223, 204, 1),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag indicator
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 20),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    height: 1,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: child,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Показать bottom sheet с билдером для полного контроля содержимого
  ///
  /// [context] - BuildContext
  /// [builder] - Функция-билдер, которая получает scrollController
  /// [initialChildSize] - Начальный размер (0.0 - 1.0), по умолчанию 0.93
  /// [minChildSize] - Минимальный размер при сворачивании, по умолчанию 0.5
  /// [maxChildSize] - Максимальный размер, по умолчанию 0.95
  static Future<T?> showCustom<T>({
    required BuildContext context,
    required Widget Function(
            BuildContext context, ScrollController scrollController)
        builder,
    double initialChildSize = 0.95,
    double minChildSize = 0.5,
    double maxChildSize = 0.95,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: initialChildSize,
        minChildSize: minChildSize,
        maxChildSize: maxChildSize,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Color.fromRGBO(226, 223, 204, 1),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag indicator
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 20),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Custom content
              Expanded(
                child: builder(context, scrollController),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Показать bottom sheet используя NavigatorState (для вызова после закрытия другого модала)
  ///
  /// [navigatorState] - NavigatorState сохранённый до закрытия предыдущего модала
  /// [builder] - Функция-билдер, которая получает scrollController
  /// [initialChildSize] - Начальный размер (0.0 - 1.0), по умолчанию 0.93
  /// [minChildSize] - Минимальный размер при сворачивании, по умолчанию 0.5
  /// [maxChildSize] - Максимальный размер, по умолчанию 0.95
  static Future<T?> showCustomWithNavigator<T>({
    required NavigatorState navigatorState,
    required Widget Function(
            BuildContext context, ScrollController scrollController)
        builder,
    double initialChildSize = 0.95,
    double minChildSize = 0.5,
    double maxChildSize = 0.95,
  }) {
    return showModalBottomSheet<T>(
      context: navigatorState.context,
      isScrollControlled: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: initialChildSize,
        minChildSize: minChildSize,
        maxChildSize: maxChildSize,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Color.fromRGBO(226, 223, 204, 1),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag indicator
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 20),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Custom content
              Expanded(
                child: builder(context, scrollController),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
