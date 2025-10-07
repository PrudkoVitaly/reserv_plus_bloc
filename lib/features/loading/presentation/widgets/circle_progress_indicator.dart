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
          color: color ?? Colors.purple,
          strokeWidth: strokeWidth ?? 4,
          backgroundColor: backgroundColor,
          value: value,
          valueColor: AlwaysStoppedAnimation<Color>(
            valueColor ?? Colors.purple,
          ),
        ),
      ),
    );
  }
}
