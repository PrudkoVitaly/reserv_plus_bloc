import 'package:equatable/equatable.dart';

abstract class LoadingEvent extends Equatable {
  const LoadingEvent();

  @override
  List<Object?> get props => [];
}

class LoadingStarted extends LoadingEvent {
  const LoadingStarted();
}

class LoadingCompleted extends LoadingEvent {
  const LoadingCompleted();
}

class LoadingError extends LoadingEvent {
  final String message;

  const LoadingError(this.message);

  @override
  List<Object?> get props => [message];
}

class LoadingBackPressed extends LoadingEvent {
  const LoadingBackPressed();
}
