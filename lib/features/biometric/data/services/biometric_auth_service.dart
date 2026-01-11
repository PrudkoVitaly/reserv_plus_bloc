import 'package:local_auth/local_auth.dart' hide BiometricType;
import 'package:local_auth/local_auth.dart' as local_auth;
import 'package:local_auth_android/local_auth_android.dart' hide BiometricType;
import 'package:local_auth_darwin/local_auth_darwin.dart' hide BiometricType;
import 'package:reserv_plus/features/biometric/domain/entities/biometric_type.dart';

class BiometricAuthService {
  final LocalAuthentication _localAuth;
  BiometricAuthService({
    required LocalAuthentication localAuth,
  }) : _localAuth = localAuth;

  /// Проверить, поддерживает ли устройство биометрию
  Future<bool> canCheckBiometric() async {
    try {
      return await _localAuth.canCheckBiometrics;
    } catch (e) {
      return false;
    }
  }

  /// Получить список доступных типов биометрии
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      final availableBiometrics = await _localAuth.getAvailableBiometrics();

      return availableBiometrics.map((biometric) {
        switch (biometric) {
          case local_auth.BiometricType.face:
            return BiometricType.face;
          case local_auth.BiometricType.fingerprint:
            return BiometricType.fingerprint;
          case local_auth.BiometricType.iris:
            return BiometricType.iris;
          case local_auth.BiometricType.weak:
            return BiometricType.fingerprint;
          case local_auth.BiometricType.strong:
            return BiometricType.fingerprint;
        }
      }).toList();
    } catch (e) {
      return [BiometricType.none];
    }
  }

  /// Запросить биометрическую аутентификацию
  Future<bool> authenticate({
    required String localizedReason,
  }) async {
    try {
      return await _localAuth.authenticate(
        localizedReason: localizedReason,
        options: const AuthenticationOptions(
          stickyAuth: false,
          biometricOnly: true,
        ),
        authMessages: const [
          AndroidAuthMessages(
            signInTitle: 'Вхід за біометричними даними',
            cancelButton: 'Скасувати',
            biometricHint: '',
            biometricNotRecognized: 'Біометрію не розпізнано',
            biometricRequiredTitle: 'Потрібна біометрія',
            biometricSuccess: 'Успішно',
            deviceCredentialsRequiredTitle: 'Потрібні облікові дані',
            deviceCredentialsSetupDescription: 'Налаштуйте облікові дані',
            goToSettingsButton: 'До налаштувань',
            goToSettingsDescription: 'Налаштуйте біометрію',
          ),
          IOSAuthMessages(
            cancelButton: 'Скасувати',
            goToSettingsButton: 'До налаштувань',
            goToSettingsDescription: 'Налаштуйте біометрію',
            lockOut: 'Біометрію заблоковано',
          ),
        ],
      );
    } catch (e) {
      return false;
    }
  }
}
