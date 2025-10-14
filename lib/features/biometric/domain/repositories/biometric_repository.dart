import 'package:reserv_plus/features/biometric/domain/entities/biometric_status.dart';

abstract class BiometricRepository {
  /// Получить статус биометрии на устройстве
  Future<BiometricStatus> getBiometricStatus();

  /// Показывает системный диалог с запросом отпечатка пальца или Face ID
  Future<bool> authenticate();

  /// Сохранить выбор пользователя (включить/выключить биометрию)
  Future<void> setBiometricEnabled(bool enabled);

  /// Возвращает выбор пользователя из SharedPreferences
  Future<bool> isBiometricEnabled();
}
