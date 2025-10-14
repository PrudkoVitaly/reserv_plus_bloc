import 'package:equatable/equatable.dart';

abstract class BiometricEvent extends Equatable {
  const BiometricEvent();

  @override
  List<Object?> get props => [];
}

/// Вызывается когда пользователь пытается войти в приложение
/// Показывает системный диалог с отпечатком/Face ID
class CheckBiometricStatusRequested extends BiometricEvent {
  const CheckBiometricStatusRequested();
}

/// Событие: Запросить биометрическую аутентификацию
/// Вызывается когда пользователь пытается войти в приложение
/// Показывает системный диалог с отпечатком/Face ID
class BiometricAuthenticationRequested extends BiometricEvent {
  const BiometricAuthenticationRequested();
}

/// Событие: Изменить настройку биометрии
/// Вызывается когда пользователь включает/выключает биометрию
/// в настройках приложения
class BiometricSettingChanged extends BiometricEvent {
  final bool isEnabled;
  const BiometricSettingChanged({required this.isEnabled});

  @override
  List<Object?> get props => [isEnabled];
}
