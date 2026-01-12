import 'package:flutter/material.dart';

/// Основная оранжевая кнопка приложения
/// Используется для главных действий: "Почати", "Оновити", "Дякую" и т.д.
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double verticalPadding;
  final double fontSize;
  final FontWeight fontWeight;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.verticalPadding = 18,
    this.fontSize = 18,
    this.fontWeight = FontWeight.w500,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(253, 135, 12, 1),
          foregroundColor: Colors.black,
          disabledBackgroundColor: const Color.fromRGBO(253, 135, 12, 1),
          padding: EdgeInsets.symmetric(vertical: verticalPadding),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          elevation: 0,
          splashFactory: NoSplash.splashFactory,
          shadowColor: Colors.transparent,
          overlayColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.black,
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: fontWeight,
                ),
              ),
      ),
    );
  }
}
