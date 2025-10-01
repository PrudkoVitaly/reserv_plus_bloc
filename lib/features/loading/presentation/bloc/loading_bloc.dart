import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/loading_repository.dart';
import 'loading_event.dart' as events;
import 'loading_state.dart' as states;

class LoadingBloc extends Bloc<events.LoadingEvent, states.LoadingState> {
  final LoadingRepository _repository;

  LoadingBloc({required LoadingRepository repository})
      : _repository = repository,
        super(const states.LoadingInitial()) {
    on<events.LoadingStarted>(_onLoadingStarted);
    on<events.LoadingCompleted>(_onLoadingCompleted);
    on<events.LoadingError>(_onLoadingError);
    on<events.LoadingBackPressed>(_onBackPressed);
  }

  void _onLoadingStarted(
      events.LoadingStarted event, Emitter<states.LoadingState> emit) async {
    emit(const states.LoadingInProgress());

    try {
      await _repository.performLoading();
      emit(const states.LoadingCompleted());
    } catch (e) {
      emit(states.LoadingError(e.toString()));
    }
  }

  void _onLoadingCompleted(
      events.LoadingCompleted event, Emitter<states.LoadingState> emit) {
    emit(const states.LoadingCompleted());
  }

  void _onLoadingError(
      events.LoadingError event, Emitter<states.LoadingState> emit) {
    emit(states.LoadingError(event.message));
  }

  void _onBackPressed(
      events.LoadingBackPressed event, Emitter<states.LoadingState> emit) {
    // Здесь можно добавить логику для обработки нажатия "Назад"
    // Например, отменить загрузку или показать диалог подтверждения
  }
}
