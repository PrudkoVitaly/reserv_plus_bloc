import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/navigation_repository.dart';
import 'main_event.dart';
import 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  final NavigationRepository _repository;

  MainBloc({required NavigationRepository repository})
      : _repository = repository,
        super(const MainInitial()) {
    on<MainInitialized>(_onInitialized);
    on<MainNavigationChanged>(_onNavigationChanged);
    on<MainContainerToggled>(_onContainerToggled);
    on<MainNotificationsChecked>(_onNotificationsChecked);
  }

  void _onInitialized(MainInitialized event, Emitter<MainState> emit) async {
    emit(const MainLoading());

    try {
      final navigationState = await _repository.getNavigationState();
      final hasNotifications = await _repository.hasNotifications();

      final updatedState = navigationState.copyWith(
        hasNotifications: hasNotifications,
      );

      emit(MainLoaded(updatedState));
    } catch (e) {
      emit(MainError(e.toString()));
    }
  }

  void _onNavigationChanged(
      MainNavigationChanged event, Emitter<MainState> emit) {
    if (state is MainLoaded) {
      final currentState = state as MainLoaded;
      final updatedState = currentState.navigationState.copyWith(
        selectedIndex: event.index,
      );

      emit(MainLoaded(updatedState));
      _repository.saveNavigationState(updatedState);
    }
  }

  void _onContainerToggled(
      MainContainerToggled event, Emitter<MainState> emit) {
    if (state is MainLoaded) {
      final currentState = state as MainLoaded;
      final updatedState = currentState.navigationState.copyWith(
        isContainerVisible: !currentState.navigationState.isContainerVisible,
      );

      emit(MainLoaded(updatedState));
    }
  }

  void _onNotificationsChecked(
      MainNotificationsChecked event, Emitter<MainState> emit) {
    if (state is MainLoaded) {
      final currentState = state as MainLoaded;
      final updatedState = currentState.navigationState.copyWith(
        hasNotifications: false, // Убираем уведомления после проверки
      );

      emit(MainLoaded(updatedState));
    }
  }
}
