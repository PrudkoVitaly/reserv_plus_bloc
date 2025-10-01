import 'package:equatable/equatable.dart';

abstract class RequestSentEvent extends Equatable {
  const RequestSentEvent();

  @override
  List<Object?> get props => [];
}

class RequestSentContinue extends RequestSentEvent {
  const RequestSentContinue();
}
