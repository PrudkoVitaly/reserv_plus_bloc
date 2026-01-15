import '../../domain/entities/pin_validation_result.dart';
import '../../domain/repositories/pin_repository.dart';
import '../services/pin_storage_service.dart';

/// Реализация репозитория для работы с PIN-кодом
///
/// Использует PinStorageService для безопасного хранения PIN.
/// Раньше здесь был хардкод "1234", теперь PIN сохраняется
/// и проверяется из защищённого хранилища.
class PinRepositoryImpl implements PinRepository {
  final PinStorageService _pinStorageService;

  PinRepositoryImpl({PinStorageService? pinStorageService})
      : _pinStorageService = pinStorageService ?? PinStorageService();

  @override
  Future<void> savePin(String pin) async {
    await _pinStorageService.savePin(pin);
  }

  @override
  Future<bool> hasPin() async {
    return await _pinStorageService.hasPin();
  }

  @override
  Future<PinValidationResult> validatePin(String pin) async {
    // Получаем сохранённый PIN из защищённого хранилища
    final savedPin = await _pinStorageService.getPin();

    // Если PIN не был создан — ошибка
    if (savedPin == null) {
      return const PinValidationResult(
        isValid: false,
        errorMessage: 'PIN-код не встановлено',
      );
    }

    // Сравниваем введённый PIN с сохранённым
    if (pin == savedPin) {
      return const PinValidationResult(
        isValid: true,
        shouldUseBiometrics: false,
      );
    } else {
      return const PinValidationResult(
        isValid: false,
        errorMessage: 'Неправильний PIN-код',
      );
    }
  }

  @override
  Future<bool> isBiometricsAvailable() async {
    // В реальном приложении здесь будет проверка доступности биометрии
    // через BiometricAuthService
    return true;
  }

  @override
  Future<PinValidationResult> authenticateWithBiometrics() async {
    // Имитация задержки биометрической аутентификации
    await Future.delayed(const Duration(seconds: 2));

    // В реальном приложении здесь будет вызов биометрической аутентификации
    return const PinValidationResult(
      isValid: false,
      errorMessage: 'Біометрична автентифікація не вдалась',
    );
  }

  @override
  Future<void> deletePin() async {
    await _pinStorageService.deletePin();
  }
}
