import 'package:reserv_plus/features/biometric/domain/entities/biometric_type.dart';

class BiometricStatus {
  final bool isAvailable;
  final bool isEnabled;
  final BiometricType type;

  const BiometricStatus({
    required this.isAvailable,
    required this.isEnabled,
    required this.type,
  });
}
