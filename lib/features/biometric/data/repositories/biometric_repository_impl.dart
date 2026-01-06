import 'package:reserv_plus/features/biometric/data/services/biometric_auth_service.dart';
import 'package:reserv_plus/features/biometric/domain/entities/biometric_status.dart';
import 'package:reserv_plus/features/biometric/domain/entities/biometric_type.dart';
import 'package:reserv_plus/features/biometric/domain/repositories/biometric_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BiometricRepositoryImpl implements BiometricRepository {
  final BiometricAuthService _biometricAuthService;
  final SharedPreferences _sharedPreferences;

  // Ключ для хранения настройки в SharedPreferences
  static const String _biometricEnabledKey = 'biometric_enabled';

  BiometricRepositoryImpl({
    required BiometricAuthService biometricAuthService,
    required SharedPreferences sharedPreferences,
  })  : _biometricAuthService = biometricAuthService,
        _sharedPreferences = sharedPreferences;

  @override
  Future<BiometricStatus> getBiometricStatus() async {
    // Проверяем, поддерживает ли устройство биометрию
    final canCheck = await _biometricAuthService.canCheckBiometric();

    // Устройство не поддерживает биометрию
    if (!canCheck) {
      return const BiometricStatus(
        isAvailable: false,
        isEnabled: false,
        type: BiometricType.none,
      );
    }

    // Получаем список доступных типов биометрии
    final availableTypes = await _biometricAuthService.getAvailableBiometrics();

    // Если нет доступных типов биометрии (нет зарегистрированных отпечатков)
    if (availableTypes.isEmpty) {
      return const BiometricStatus(
        isAvailable: false,
        isEnabled: false,
        type: BiometricType.none,
      );
    }

    final biometricType = availableTypes.first;

    // Проверяем, включена ли биометрия в настройках приложения
    final isEnabled = await isBiometricEnabled();

    return BiometricStatus(
      isAvailable: true,
      isEnabled: isEnabled, // Используем значение из настроек
      type: biometricType,
    );
  }

  @override
  Future<bool> authenticate() async {
    try {
      // Сначала проверяем статус
      final status = await getBiometricStatus();

      // Если биометрия недоступна или отключена в настройках - не аутентифицируем
      if (!status.isAvailable || !status.isEnabled) {
        return false;
      }

      return await _biometricAuthService.authenticate(
        localizedReason: 'Вхід за біометричними даними',
      );
    } catch (e) {
      return false;
    }
  }

  // Сохраняем значение в SharedPreferences
  @override
  Future<void> setBiometricEnabled(bool enabled) async {
    await _sharedPreferences.setBool(_biometricEnabledKey, enabled);
  }

  // Читаем значение из SharedPreferences
  @override
  Future<bool> isBiometricEnabled() async {
    return _sharedPreferences.getBool(_biometricEnabledKey) ?? true; // По умолчанию включена
  }
}
