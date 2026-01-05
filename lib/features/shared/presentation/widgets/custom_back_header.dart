import 'package:flutter/material.dart';

/// Переиспользуемый виджет заголовка с кнопкой назад
/// Обеспечивает консистентность высоты и стиля на всех страницах
class CustomBackHeader extends StatelessWidget {
  final String? title;
  final VoidCallback? onBack;
  final double topPadding;

  const CustomBackHeader({
    super.key,
    this.title,
    this.onBack,
    this.topPadding = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: topPadding),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: IconButton(
            onPressed: onBack ?? () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.black,
              size: 28,
            ),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
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
