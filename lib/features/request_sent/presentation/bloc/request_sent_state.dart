import 'package:equatable/equatable.dart';

abstract class RequestSentState extends Equatable {
  const RequestSentState();

  @override
  List<Object?> get props => [];
}

class RequestSentInitial extends RequestSentState {
  const RequestSentInitial();
}

class RequestSentLoading extends RequestSentState {
  const RequestSentLoading();
}

class RequestSentCompleted extends RequestSentState {
  const RequestSentCompleted();
}

class RequestSentError extends RequestSentState {
  final String message;

  const RequestSentError(this.message);

  @override
  List<Object?> get props => [message];
}
