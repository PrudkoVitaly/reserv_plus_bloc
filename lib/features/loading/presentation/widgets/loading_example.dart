import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/loading_bloc.dart';
import '../bloc/loading_event.dart';
import 'loading_widget.dart';
import 'loading_overlay.dart';
import 'loading_button.dart';

class LoadingExample extends StatelessWidget {
  const LoadingExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loading Example'),
      ),
      body: LoadingOverlay(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                'Приклади використання компонентів завантаження',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Простой виджет загрузки
              const LoadingWidget(
                showBackground: false,
                child: Text('Контент завантажується...'),
              ),

              const SizedBox(height: 20),

              // Кнопка с загрузкой
              LoadingButton(
                text: 'Завантажити дані',
                onPressed: () {
                  context.read<LoadingBloc>().add(const LoadingStarted());
                },
              ),

              const SizedBox(height: 20),

              // Кнопка с кастомными цветами
              LoadingButton(
                text: 'Зберегти',
                backgroundColor: Colors.green,
                textColor: Colors.white,
                onPressed: () {
                  // Логика сохранения
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
