import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/registry_repository.dart';
import 'registry_event.dart';
import 'registry_state.dart';

class RegistryBloc extends Bloc<RegistryEvent, RegistryState> {
  final RegistryRepository _repository;

  RegistryBloc({required RegistryRepository repository})
      : _repository = repository,
        super(const RegistryInitial()) {
    on<RegistryLoadData>(_onLoadData);
    on<RegistryNavigationChanged>(_onNavigationChanged);
    on<RegistryRetry>(_onRetry);
  }

  void _onLoadData(RegistryLoadData event, Emitter<RegistryState> emit) async {
    emit(const RegistryLoading());

    try {
      final data = await _repository.getRegistryData();
      emit(RegistrySuccess(data: data));
    } catch (e) {
      emit(RegistryError(message: e.toString()));
    }
  }

  void _onNavigationChanged(
      RegistryNavigationChanged event, Emitter<RegistryState> emit) {
    if (state is RegistrySuccess) {
      final currentState = state as RegistrySuccess;
      emit(RegistrySuccess(
        data: currentState.data,
        currentTabIndex: event.index,
      ));
    } else if (state is RegistryLoading) {
      emit(RegistryLoading(currentTabIndex: event.index));
    } else if (state is RegistryError) {
      final currentState = state as RegistryError;
      emit(RegistryError(
        message: currentState.message,
        currentTabIndex: event.index,
      ));
    }
  }

  void _onRetry(RegistryRetry event, Emitter<RegistryState> emit) {
    add(const RegistryLoadData());
  }
}
