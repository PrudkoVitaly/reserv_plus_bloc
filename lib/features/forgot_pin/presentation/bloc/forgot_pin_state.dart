import 'package:equatable/equatable.dart';
import 'package:reserv_plus/features/forgot_pin/domain/entities/forgot_pin_data.dart';

abstract class ForgotPinState extends Equatable {
  const ForgotPinState();

  @override
  List<Object?> get props => [];
}

class ForgotPinInitial extends ForgotPinState {}

class ForgotPinLoading extends ForgotPinState {
  final ForgotPinData data;

  const ForgotPinLoading({required this.data});

  @override
  List<Object?> get props => [data];
}

class ForgotPinLoaded extends ForgotPinState {
  final ForgotPinData data;

  const ForgotPinLoaded({required this.data});

  @override
  List<Object?> get props => [data];
}

class ForgotPinAuthorizationInProgress extends ForgotPinState {
  final ForgotPinData data;

  const ForgotPinAuthorizationInProgress({required this.data});

  @override
  List<Object?> get props => [data];
}

class ForgotPinAuthorizationSuccess extends ForgotPinState {}

class ForgotPinAuthorizationFailure extends ForgotPinState {
  final String error;

  const ForgotPinAuthorizationFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
