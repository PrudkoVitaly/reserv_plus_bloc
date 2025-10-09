import 'package:flutter/material.dart';

/// Индикатор загрузки, который появляется только если загрузка длится дольше заданного времени
/// Предотвращает "мелькание" индикатора при быстрых загрузках
class DelayedLoadingIndicator extends StatefulWidget {
  final Duration delay;
  final Color color;
  final double strokeWidth;

  const DelayedLoadingIndicator({
    super.key,
    this.delay = const Duration(milliseconds: 200),
    this.color = Colors.black,
    this.strokeWidth = 4,
  });

  @override
  State<DelayedLoadingIndicator> createState() =>
      _DelayedLoadingIndicatorState();
}

class _DelayedLoadingIndicatorState extends State<DelayedLoadingIndicator> {
  bool _showIndicator = false;

  @override
  void initState() {
    super.initState();
    // Показываем индикатор только после задержки
    Future.delayed(widget.delay, () {
      if (mounted) {
        setState(() {
          _showIndicator = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_showIndicator) {
      // Пока индикатор не должен показываться - возвращаем пустой виджет
      return const SizedBox.shrink();
    }

    return Center(
      child: CircularProgressIndicator(
        color: widget.color,
        strokeWidth: widget.strokeWidth,
      ),
    );
  }
}
