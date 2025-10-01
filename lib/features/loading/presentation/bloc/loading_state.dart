import 'package:equatable/equatable.dart';

abstract class LoadingState extends Equatable {
  const LoadingState();

  @override
  List<Object?> get props => [];
}

class LoadingInitial extends LoadingState {
  const LoadingInitial();
}

class LoadingInProgress extends LoadingState {
  final double progress;

  const LoadingInProgress({this.progress = 0.0});

  @override
  List<Object?> get props => [progress];
}

class LoadingCompleted extends LoadingState {
  const LoadingCompleted();
}

class LoadingError extends LoadingState {
  final String message;

  const LoadingError(this.message);

  @override
  List<Object?> get props => [message];
}
