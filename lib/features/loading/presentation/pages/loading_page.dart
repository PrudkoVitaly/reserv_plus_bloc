import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/loading_bloc.dart';
import '../bloc/loading_event.dart' as events;
import '../bloc/loading_state.dart' as states;

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    // Запускаем загрузку
    context.read<LoadingBloc>().add(const events.LoadingStarted());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoadingBloc, states.LoadingState>(
      listener: (context, state) {
        if (state is states.LoadingCompleted) {
          // Переходим на предыдущий экран после завершения загрузки
          Navigator.pop(context);
        } else if (state is states.LoadingError) {
          // Показываем ошибку
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Помилка: ${state.message}'),
              action: SnackBarAction(
                label: 'Спробувати знову',
                onPressed: () {
                  context
                      .read<LoadingBloc>()
                      .add(const events.LoadingStarted());
                },
              ),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(226, 223, 204, 1),
        body: BlocBuilder<LoadingBloc, states.LoadingState>(
          builder: (context, state) {
            if (state is states.LoadingInProgress) {
              return _buildLoadingContent(state);
            } else if (state is states.LoadingError) {
              return _buildErrorContent(state);
            } else {
              return _buildLoadingContent(const states.LoadingInProgress());
            }
          },
        ),
      ),
    );
  }

  Widget _buildLoadingContent(states.LoadingState state) {
    return const Center(
      child: _GradientCircularProgressIndicator(
        size: 30,
        strokeWidth: 2,
      ),
    );
  }

  Widget _buildErrorContent(states.LoadingError state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 80,
            color: Colors.red,
          ),
          const SizedBox(height: 20),
          const Text(
            'Помилка завантаження',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            state.message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              context.read<LoadingBloc>().add(const events.LoadingStarted());
            },
            child: const Text('Спробувати знову'),
          ),
        ],
      ),
    );
  }
}

class _GradientCircularProgressIndicator extends StatefulWidget {
  final double size;
  final double strokeWidth;

  const _GradientCircularProgressIndicator({
    this.size = 48,
    this.strokeWidth = 3,
  });

  @override
  State<_GradientCircularProgressIndicator> createState() =>
      _GradientCircularProgressIndicatorState();
}

class _GradientCircularProgressIndicatorState
    extends State<_GradientCircularProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _controller.value * 2 * math.pi,
          child: CustomPaint(
            size: Size(widget.size, widget.size),
            painter: _GradientCirclePainter(
              strokeWidth: widget.strokeWidth,
            ),
          ),
        );
      },
    );
  }
}

class _GradientCirclePainter extends CustomPainter {
  final double strokeWidth;

  _GradientCirclePainter({required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final gradient = SweepGradient(
      startAngle: 0,
      endAngle: math.pi * 2,
      colors: const [
        Color.fromRGBO(200, 197, 180, 1), // Серый (конец/начало)
        Color.fromRGBO(35, 34, 30, 1), // Чёрный
        Color.fromRGBO(200, 197, 180, 1), // Серый
      ],
      stops: const [0.0, 0.75, 1.0],
    );

    final paint = Paint()
      ..shader =
          gradient.createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
