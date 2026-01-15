import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Сервис для безопасного хранения PIN-кода
///
/// Использует flutter_secure_storage который:
/// - Android: EncryptedSharedPreferences (AES шифрование)
/// - iOS: Keychain (системное защищённое хранилище)
///
/// Это безопаснее чем SharedPreferences, потому что данные зашифрованы
/// и не могут быть прочитаны даже на рутованном устройстве.
class PinStorageService {
  // Ключ под которым хранится PIN
  static const String _pinKey = 'user_pin_code';

  // Настройки для Android - используем EncryptedSharedPreferences
  static const _androidOptions = AndroidOptions(
    encryptedSharedPreferences: true,
  );

  // Экземпляр защищённого хранилища
  final FlutterSecureStorage _storage;

  PinStorageService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage(aOptions: _androidOptions);

  /// Сохранить PIN-код
  ///
  /// [pin] - 4-значный PIN-код
  Future<void> savePin(String pin) async {
    await _storage.write(key: _pinKey, value: pin);
  }

  /// Получить сохранённый PIN-код
  ///
  /// Возвращает null если PIN ещё не был создан
  Future<String?> getPin() async {
    return await _storage.read(key: _pinKey);
  }

  /// Проверить есть ли сохранённый PIN
  ///
  /// Используется для определения: показывать экран создания PIN
  /// или экран входа по PIN
  Future<bool> hasPin() async {
    final pin = await getPin();
    return pin != null && pin.isNotEmpty;
  }

  /// Удалить PIN-код
  ///
  /// Используется при выходе из аккаунта или сбросе приложения
  Future<void> deletePin() async {
    await _storage.delete(key: _pinKey);
  }
}
