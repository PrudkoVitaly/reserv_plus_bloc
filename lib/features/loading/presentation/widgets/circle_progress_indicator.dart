import 'package:flutter/material.dart';
import 'package:reserv_plus/features/shared/presentation/widgets/delayed_loading_indicator.dart';

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
      body: DelayedLoadingIndicator(
        color: color ?? Colors.purple,
        strokeWidth: strokeWidth ?? 4,
        delay: const Duration(milliseconds: 0), // Показываем сразу
      ),
    );
  }
}
