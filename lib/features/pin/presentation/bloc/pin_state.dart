import 'package:equatable/equatable.dart';

abstract class PinState extends Equatable {
  const PinState();

  @override
  List<Object?> get props => [];
}

class PinInitial extends PinState {
  final bool isBiometricsAvailable;
  final bool isBiometricsModalVisible;

  const PinInitial({
    this.isBiometricsAvailable = false,
    this.isBiometricsModalVisible = false,
  });

  @override
  List<Object?> get props => [isBiometricsAvailable, isBiometricsModalVisible];
}

class PinEntering extends PinState {
  final List<String> enteredPin;
  final bool isBiometricsAvailable;
  final bool isBiometricsModalVisible;

  const PinEntering({
    required this.enteredPin,
    this.isBiometricsAvailable = false,
    this.isBiometricsModalVisible = false,
  });

  @override
  List<Object?> get props =>
      [enteredPin, isBiometricsAvailable, isBiometricsModalVisible];
}

class PinValidating extends PinState {
  const PinValidating();
}

class PinSuccess extends PinState {
  const PinSuccess();
}

class PinError extends PinState {
  final String message;
  final List<String> enteredPin;
  final bool isBiometricsAvailable;
  final bool isBiometricsModalVisible;

  const PinError({
    required this.message,
    this.enteredPin = const [],
    this.isBiometricsAvailable = false,
    this.isBiometricsModalVisible = false,
  });

  @override
  List<Object?> get props =>
      [message, enteredPin, isBiometricsAvailable, isBiometricsModalVisible];
}

class PinBiometricsAvailable extends PinState {
  const PinBiometricsAvailable();
}

class PinBiometricsAuthenticating extends PinState {
  const PinBiometricsAuthenticating();
}
