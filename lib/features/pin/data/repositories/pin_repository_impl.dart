import '../../domain/entities/pin_validation_result.dart';
import '../../domain/repositories/pin_repository.dart';

class PinRepositoryImpl implements PinRepository {
  // Временный хардкод - в реальном приложении будет проверка с сервером
  static const String _correctPin = "1234";

  @override
  Future<PinValidationResult> validatePin(String pin) async {
    // Убираем задержку для мгновенной анимации
    // await Future.delayed(const Duration(milliseconds: 500));

    if (pin == _correctPin) {
      return const PinValidationResult(
        isValid: true,
        shouldUseBiometrics: false,
      );
    } else {
      return const PinValidationResult(
        isValid: false,
        errorMessage: 'Неправильный пин-код!',
      );
    }
  }

  @override
  Future<bool> isBiometricsAvailable() async {
    // В реальном приложении здесь будет проверка доступности биометрии
    return true;
  }

  @override
  Future<PinValidationResult> authenticateWithBiometrics() async {
    // Имитация задержки биометрической аутентификации
    await Future.delayed(const Duration(seconds: 2));

    // В реальном приложении здесь будет вызов биометрической аутентификации
    // Пока что имитируем, что биометрия может быть неуспешной
    return const PinValidationResult(
      isValid: false,
      errorMessage: 'Биометрическая аутентификация не удалась',
    );
  }
}
