import 'package:flutter/material.dart';

class ModalContainerWidget extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final Widget? child;

  const ModalContainerWidget({
    super.key,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.fontWeight,
    this.padding,
    this.borderRadius,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: borderRadius ?? BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child ??
          Text(
            text,
            style: TextStyle(
              fontSize: fontSize ?? 24,
              fontWeight: fontWeight ?? FontWeight.w500,
              height: 1.0,
              color: textColor ?? Colors.black,
            ),
          ),
    );
  }
}
