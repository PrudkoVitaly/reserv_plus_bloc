import 'package:flutter/material.dart';

class CircleProgressIndicator extends StatelessWidget {
  final Color? color;
  final double? strokeWidth;
  final Color? backgroundColor;
  final double? value;
  final Color? valueColor;
  final StrokeCap? strokeCap;

  const CircleProgressIndicator({
    super.key,
    this.color,
    this.strokeWidth,
    this.backgroundColor,
    this.value,
    this.valueColor,
    this.strokeCap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(226, 223, 204, 1),
      body: Center(
        child: CircularProgressIndicator(
          color: color ?? const Color.fromRGBO(253, 135, 12, 1),
          strokeWidth: strokeWidth ?? 4,
          backgroundColor: backgroundColor ?? Colors.black26,
          value: value,
          valueColor: AlwaysStoppedAnimation<Color>(
            valueColor ?? Colors.black,
          ),
          strokeAlign: 1,
          strokeCap: strokeCap ?? StrokeCap.round,
        ),
      ),
    );
  }
}
