import 'package:flutter/material.dart';

class BottomSheetModal extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget>? actions;
  final bool isDismissible;
  final VoidCallback? onDismiss;

  const BottomSheetModal({
    super.key,
    required this.title,
    required this.content,
    this.actions,
    this.isDismissible = true,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Индикатор для перетаскивания
              Container(
                margin: const EdgeInsets.only(top: 10),
                height: 5,
                width: 45,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              // Заголовок
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Контент
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: content,
                  ),
                ),
              ),
              // Действия
              if (actions != null)
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: actions!,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
