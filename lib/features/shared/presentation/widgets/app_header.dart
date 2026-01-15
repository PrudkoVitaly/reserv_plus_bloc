import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:reserv_plus/features/support/presentation/pages/support_page.dart';

/// Универсальный виджет заголовка страницы
/// Обеспечивает консистентность высоты и стиля на всех страницах
///
/// Параметры:
/// - [title] - заголовок страницы (опционально)
/// - [onBack] - кастомное действие при нажатии назад (по умолчанию Navigator.pop)
/// - [topPadding] - отступ сверху (по умолчанию 2)
/// - [trailing] - кастомный виджет справа (опционально)
/// - [showHelpButton] - показать встроенную кнопку "?" (по умолчанию false)
/// - [onHelpTap] - кастомное действие при нажатии на "?" (по умолчанию открывает SupportPage)
class AppHeader extends StatelessWidget {
  final String? title;
  final VoidCallback? onBack;
  final double topPadding;
  final Widget? trailing;
  final bool showHelpButton;
  final VoidCallback? onHelpTap;

  const AppHeader({
    super.key,
    this.title,
    this.onBack,
    this.topPadding = 2,
    this.trailing,
    this.showHelpButton = false,
    this.onHelpTap,
  });

  void _openSupportPage(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const SupportPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SharedAxisTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.horizontal,
            fillColor: Colors.transparent,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: topPadding),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: onBack ?? () => Navigator.of(context).pop(),
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.black,
                  size: 28,
                ),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              if (showHelpButton)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: onHelpTap ?? () => _openSupportPage(context),
                    child: Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          '?',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              else if (trailing != null)
                trailing!,
            ],
          ),
        ),
        if (title != null) ...[
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              title!,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                height: 1,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
