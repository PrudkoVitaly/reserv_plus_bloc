import 'package:equatable/equatable.dart';
import 'package:reserv_plus/features/biometric/domain/entities/biometric_status.dart';

abstract class BiometricState extends Equatable {
  const BiometricState();

  @override
  List<Object?> get props => [];
}

class BiometricInitial extends BiometricState {
  const BiometricInitial();
}

class BiometricLoading extends BiometricState {
  const BiometricLoading();
}

class BiometricStatusLoaded extends BiometricState {
  final BiometricStatus status;
  const BiometricStatusLoaded({required this.status});

  @override
  List<Object?> get props => [status];
}

class BiometricAuthenticating extends BiometricState {
  const BiometricAuthenticating();
}

class BiometricAuthenticationSuccess extends BiometricState {
  const BiometricAuthenticationSuccess();
}

class BiometricAuthenticationFailure extends BiometricState {
  final String message;

  const BiometricAuthenticationFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class BiometricError extends BiometricState {
  final String message;

  const BiometricError({required this.message});

  @override
  List<Object?> get props => [message];
}
