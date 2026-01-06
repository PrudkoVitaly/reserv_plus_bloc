import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  // Используем тот же ключ что и в BiometricRepositoryImpl
  static const String _biometricEnabledKey = 'biometric_enabled';
  static const String _offlineQrEnabledKey = 'settings_offline_qr_enabled';

  /// Получить настройку биометрии
  static Future<bool> getBiometricEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_biometricEnabledKey) ?? true; // По умолчанию включена
  }

  /// Сохранить настройку биометрии
  static Future<void> setBiometricEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_biometricEnabledKey, value);
  }

  /// Получить настройку офлайн QR
  static Future<bool> getOfflineQrEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_offlineQrEnabledKey) ?? false; // По умолчанию выключена
  }

  /// Сохранить настройку офлайн QR
  static Future<void> setOfflineQrEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_offlineQrEnabledKey, value);
  }
}
