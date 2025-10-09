import 'package:flutter/material.dart';
import 'package:reserv_plus/features/shared/presentation/widgets/delayed_loading_indicator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/loading_bloc.dart';
import '../bloc/loading_state.dart';
import 'circle_progress_indicator.dart';

class LoadingWidget extends StatelessWidget {
  final Widget? child;
  final bool showBackground;

  const LoadingWidget({
    super.key,
    this.child,
    this.showBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoadingBloc, LoadingState>(
      builder: (context, state) {
        if (state is LoadingInProgress) {
          return _buildLoadingContent(state);
        } else if (state is LoadingError) {
          return _buildErrorContent(state);
        } else {
          return child ?? const SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildLoadingContent(LoadingInProgress state) {
    if (showBackground) {
      return const CircleProgressIndicator();
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const DelayedLoadingIndicator(
              color: Colors.purple,
              delay: Duration(
                  milliseconds:
                      0), // Показываем сразу для явного экрана загрузки
            ),
            const SizedBox(height: 20),
            const Text(
              'Завантаження...',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            if (state.progress > 0) ...[
              const SizedBox(height: 10),
              LinearProgressIndicator(
                value: state.progress,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color.fromRGBO(253, 135, 12, 1),
                ),
              ),
            ],
          ],
        ),
      );
    }
  }

  Widget _buildErrorContent(LoadingError state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 60,
            color: Colors.red,
          ),
          const SizedBox(height: 20),
          const Text(
            'Помилка завантаження',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            state.message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Здесь можно добавить логику для повторной попытки
            },
            child: const Text('Спробувати знову'),
          ),
        ],
      ),
    );
  }
}
