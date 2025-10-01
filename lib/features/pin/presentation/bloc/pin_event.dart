import 'package:equatable/equatable.dart';

abstract class PinEvent extends Equatable {
  const PinEvent();

  @override
  List<Object?> get props => [];
}

class PinStarted extends PinEvent {
  const PinStarted();
}

class PinNumberPressed extends PinEvent {
  final String number;

  const PinNumberPressed(this.number);

  @override
  List<Object?> get props => [number];
}

class PinDeletePressed extends PinEvent {
  const PinDeletePressed();
}

class PinSubmitted extends PinEvent {
  const PinSubmitted();
}

class PinBiometricsPressed extends PinEvent {
  const PinBiometricsPressed();
}

class PinBiometricsCancelled extends PinEvent {
  const PinBiometricsCancelled();
}

class PinReset extends PinEvent {
  const PinReset();
}
