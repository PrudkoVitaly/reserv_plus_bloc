import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/vacancies_repository.dart';
import 'vacancies_event.dart';
import 'vacancies_state.dart';

class VacanciesBloc extends Bloc<VacanciesEvent, VacanciesState> {
  final VacanciesRepository _repository;

  VacanciesBloc({required VacanciesRepository repository})
      : _repository = repository,
        super(const VacanciesInitial()) {
    on<VacanciesInitialized>(_onInitialized);
    on<VacanciesStartPressed>(_onStartPressed);
    on<VacanciesSetDontShowAgain>(_onSetDontShowAgain);
    on<VacanciesPageOpened>(_onPageOpened);
  }

  void _onInitialized(
      VacanciesInitialized event, Emitter<VacanciesState> emit) async {
    emit(const VacanciesLoading());

    try {
      final shouldShowOnboarding = await _repository.shouldShowOnboarding();
      // Всегда показываем онбординг при инициализации (если пользователь не поставил галочку)
      emit(VacanciesLoaded(showOnboarding: shouldShowOnboarding));
    } catch (e) {
      emit(VacanciesError(e.toString()));
    }
  }

  void _onStartPressed(
      VacanciesStartPressed event, Emitter<VacanciesState> emit) async {
    if (state is VacanciesLoaded) {
      final currentState = state as VacanciesLoaded;
      emit(currentState.copyWith(showOnboarding: false));
    }
  }

  void _onSetDontShowAgain(
      VacanciesSetDontShowAgain event, Emitter<VacanciesState> emit) async {
    if (state is VacanciesLoaded) {
      await _repository.setDontShowAgain(event.value);
    }
  }

  void _onPageOpened(
      VacanciesPageOpened event, Emitter<VacanciesState> emit) async {
    emit(const VacanciesLoading());

    try {
      final shouldShowOnboarding = await _repository.shouldShowOnboarding();
      emit(VacanciesLoaded(showOnboarding: shouldShowOnboarding));
    } catch (e) {
      emit(VacanciesError(e.toString()));
    }
  }
}