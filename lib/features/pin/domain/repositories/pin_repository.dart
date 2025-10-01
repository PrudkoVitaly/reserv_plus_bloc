import '../entities/pin_validation_result.dart';

abstract class PinRepository {
  /// Проверяет правильность PIN-кода
  Future<PinValidationResult> validatePin(String pin);

  /// Проверяет, доступна ли биометрия
  Future<bool> isBiometricsAvailable();

  /// Аутентификация через биометрию
  Future<PinValidationResult> authenticateWithBiometrics();
}
