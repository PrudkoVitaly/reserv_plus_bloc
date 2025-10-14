import 'package:equatable/equatable.dart';

abstract class ForgotPinEvent extends Equatable {
  const ForgotPinEvent();

  @override
  List<Object?> get props => [];
}

class ForgotPinInitialized extends ForgotPinEvent {}

class ForgotPinAuthorizePressed extends ForgotPinEvent {}

class ForgotPinCancelPressed extends ForgotPinEvent {}
