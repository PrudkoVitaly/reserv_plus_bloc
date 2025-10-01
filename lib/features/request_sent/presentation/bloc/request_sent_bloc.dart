import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/request_sent_repository.dart';
import 'request_sent_event.dart';
import 'request_sent_state.dart';

class RequestSentBloc extends Bloc<RequestSentEvent, RequestSentState> {
  final RequestSentRepository _repository;

  RequestSentBloc({required RequestSentRepository repository})
      : _repository = repository,
        super(const RequestSentInitial()) {
    on<RequestSentContinue>(_onRequestSentContinue);
  }

  void _onRequestSentContinue(
      RequestSentContinue event, Emitter<RequestSentState> emit) async {
    emit(const RequestSentLoading());

    try {
      await _repository.logRequestSent();
      emit(const RequestSentCompleted());
    } catch (e) {
      emit(RequestSentError(e.toString()));
    }
  }
}
