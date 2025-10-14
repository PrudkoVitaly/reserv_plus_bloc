import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/biometric_bloc.dart';
import '../bloc/biometric_event.dart';
import '../bloc/biometric_state.dart';

/// Overlay для биометрической аутентификации
///
/// Показывается поверх любого экрана
class BiometricOverlay extends StatelessWidget {
  final VoidCallback? onCancel;
  final VoidCallback? onSuccess;

  const BiometricOverlay({
    super.key,
    this.onCancel,
    this.onSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<BiometricBloc, BiometricState>(
      listener: (context, state) {
        if (state is BiometricAuthenticationSuccess) {
          onSuccess?.call();
        } else if (state is BiometricAuthenticationFailure ||
            state is BiometricError) {
          // Показываем ошибку, но не закрываем overlay
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state is BiometricAuthenticationFailure
                    ? state.message
                    : (state as BiometricError).message,
              ),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      child: BlocBuilder<BiometricBloc, BiometricState>(
        builder: (context, state) {
          // Запрашиваем статус если еще не загружен
          if (state is BiometricInitial) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context
                  .read<BiometricBloc>()
                  .add(const CheckBiometricStatusRequested());
            });
          }

          // Автоматически запускаем аутентификацию если биометрия доступна
          if (state is BiometricStatusLoaded &&
              state.status.isAvailable &&
              state.status.isEnabled) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context
                  .read<BiometricBloc>()
                  .add(const BiometricAuthenticationRequested());
            });
          }

          return Container(
            color: Colors.black54, // Полупрозрачный фон
            child: Center(
              child: Container(
                margin: const EdgeInsets.all(24),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Заголовок
                    _buildTitle(state),
                    const SizedBox(height: 24),

                    // Иконка
                    _buildIcon(state),
                    const SizedBox(height: 24),

                    // Описание
                    _buildDescription(state),
                    const SizedBox(height: 32),

                    // Кнопки
                    _buildButtons(context, state),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Заголовок
  Widget _buildTitle(BiometricState state) {
    String title;

    if (state is BiometricLoading) {
      title = 'Перевірка біометрії...';
    } else if (state is BiometricAuthenticating) {
      title = 'Автентифікація...';
    } else if (state is BiometricAuthenticationSuccess) {
      title = 'Успішно!';
    } else if (state is BiometricAuthenticationFailure) {
      title = 'Не вдалося';
    } else if (state is BiometricError) {
      title = 'Помилка';
    } else if (state is BiometricStatusLoaded) {
      title = 'Вхід за біометричними даними';
    } else {
      title = 'Біометрична автентифікація';
    }

    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      textAlign: TextAlign.center,
    );
  }

  /// Иконка
  Widget _buildIcon(BiometricState state) {
    if (state is BiometricLoading || state is BiometricAuthenticating) {
      return const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
      );
    }

    IconData icon;
    Color color;

    if (state is BiometricAuthenticationSuccess) {
      icon = Icons.check_circle;
      color = Colors.green;
    } else if (state is BiometricAuthenticationFailure ||
        state is BiometricError) {
      icon = Icons.error;
      color = Colors.red;
    } else if (state is BiometricStatusLoaded && state.status.isAvailable) {
      icon = Icons.fingerprint;
      color = const Color.fromRGBO(70, 164, 164, 1.0);
    } else {
      icon = Icons.fingerprint_outlined;
      color = Colors.grey;
    }

    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: state is BiometricStatusLoaded && state.status.isAvailable
            ? const Color.fromRGBO(35, 34, 30, 1)
            : Colors.grey.shade200,
      ),
      child: Icon(
        icon,
        size: 50,
        color: color,
      ),
    );
  }

  /// Описание
  Widget _buildDescription(BiometricState state) {
    String description;

    if (state is BiometricLoading) {
      description = 'Перевіряємо доступність біометрії...';
    } else if (state is BiometricAuthenticating) {
      description = 'Прикосніться до сканера відбитка пальця.';
    } else if (state is BiometricAuthenticationSuccess) {
      description = 'Автентифікація пройшла успішно!';
    } else if (state is BiometricAuthenticationFailure) {
      description = 'Спробуйте ще раз або використайте PIN-код.';
    } else if (state is BiometricError) {
      description = 'Виникла помилка. Спробуйте пізніше.';
    } else if (state is BiometricStatusLoaded) {
      if (!state.status.isAvailable) {
        description = 'Біометрія недоступна на цьому пристрої.';
      } else if (!state.status.isEnabled) {
        description = 'Біометрія вимкнена в налаштуваннях.';
      } else {
        description = 'Прикосніться до сканера відбитка пальця.';
      }
    } else {
      description = 'Готово до автентифікації.';
    }

    return Text(
      description,
      style: TextStyle(
        fontSize: 14,
        color: Colors.grey[600],
      ),
      textAlign: TextAlign.center,
    );
  }

  /// Кнопки
  Widget _buildButtons(BuildContext context, BiometricState state) {
    return Row(
      children: [
        // Кнопка "Скасувати"
        Expanded(
          child: TextButton(
            onPressed: onCancel,
            child: const Text(
              'Скасувати',
              style: TextStyle(
                color: Color.fromRGBO(70, 164, 164, 1.0),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        // Кнопка "Автентифікуватися"
        if (state is BiometricStatusLoaded &&
            state.status.isAvailable &&
            state.status.isEnabled)
          Expanded(
            child: ElevatedButton(
              onPressed: state is BiometricAuthenticating
                  ? null
                  : () {
                      context.read<BiometricBloc>().add(
                            const BiometricAuthenticationRequested(),
                          );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                state is BiometricAuthenticating
                    ? 'Зачекайте...'
                    : 'Автентифікуватися',
              ),
            ),
          ),
      ],
    );
  }
}
