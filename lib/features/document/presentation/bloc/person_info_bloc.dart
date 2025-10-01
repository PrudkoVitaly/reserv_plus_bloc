import 'package:flutter_bloc/flutter_bloc.dart';
import 'person_info_event.dart';
import 'person_info_state.dart';

class PersonInfoBloc extends Bloc<PersonInfoEvent, PersonInfoState> {
  PersonInfoBloc() : super(const PersonInfoInitial()) {
    on<PersonInfoLoadData>(_onLoadData);
    on<PersonInfoShowModal>(_onShowModal);
    on<PersonInfoHideModal>(_onHideModal);
  }

  void _onLoadData(
      PersonInfoLoadData event, Emitter<PersonInfoState> emit) async {
    emit(const PersonInfoLoading());

    try {
      // Имитация загрузки данных
      await Future.delayed(const Duration(milliseconds: 500));
      emit(const PersonInfoLoaded());
    } catch (e) {
      emit(PersonInfoError(e.toString()));
    }
  }

  void _onShowModal(PersonInfoShowModal event, Emitter<PersonInfoState> emit) {
    if (state is PersonInfoLoaded) {
      final currentState = state as PersonInfoLoaded;
      emit(currentState.copyWith(isModalVisible: true));
    }
  }

  void _onHideModal(PersonInfoHideModal event, Emitter<PersonInfoState> emit) {
    if (state is PersonInfoLoaded) {
      final currentState = state as PersonInfoLoaded;
      emit(currentState.copyWith(isModalVisible: false));
    }
  }
}
