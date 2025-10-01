import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
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
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(226, 223, 204, 1),
          leading: IconButton(
            padding: const EdgeInsets.only(left: 15),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 26,
            ),
            onPressed: () {
              context
                  .read<LoadingBloc>()
                  .add(const events.LoadingBackPressed());
              Navigator.pop(context);
            },
          ),
        ),
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LoadingAnimationWidget.staggeredDotsWave(
            color: const Color.fromRGBO(253, 135, 12, 1),
            size: 70,
          ),
          const SizedBox(height: 30),
          const Text(
            'Завантаження...',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          if (state is states.LoadingInProgress) ...[
            const SizedBox(height: 20),
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
