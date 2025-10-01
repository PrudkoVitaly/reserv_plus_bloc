import 'package:equatable/equatable.dart';

class PinValidationResult extends Equatable {
  final bool isValid;
  final String? errorMessage;
  final bool shouldUseBiometrics;

  const PinValidationResult({
    required this.isValid,
    this.errorMessage,
    this.shouldUseBiometrics = false,
  });

  @override
  List<Object?> get props => [isValid, errorMessage, shouldUseBiometrics];
}
