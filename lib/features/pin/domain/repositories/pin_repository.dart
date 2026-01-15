import '../entities/pin_validation_result.dart';

abstract class PinRepository {
  /// Сохраняет новый PIN-код в защищённое хранилище
  /// Вызывается после успешного подтверждения PIN в ConfirmPinPage
  Future<void> savePin(String pin);

  /// Проверяет, был ли уже создан PIN-код
  /// Используется при запуске для определения:
  /// - true → показать экран входа (PinPage)
  /// - false → показать экран создания PIN (CreatePinPage)
  Future<bool> hasPin();

  /// Проверяет правильность введённого PIN-кода
  /// Сравнивает с сохранённым в защищённом хранилище
  Future<PinValidationResult> validatePin(String pin);

  /// Проверяет, доступна ли биометрия на устройстве
  Future<bool> isBiometricsAvailable();

  /// Аутентификация через биометрию (Face ID / отпечаток)
  Future<PinValidationResult> authenticateWithBiometrics();

  /// Удаляет PIN-код (при выходе из аккаунта)
  Future<void> deletePin();
}
