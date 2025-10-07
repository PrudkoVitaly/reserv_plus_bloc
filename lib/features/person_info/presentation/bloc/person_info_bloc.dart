import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_person_info.dart';
import 'person_info_event.dart';
import 'person_info_state.dart';

class PersonInfoBloc extends Bloc<PersonInfoEvent, PersonInfoState> {
  final GetPersonInfo _getPersonInfo;

  PersonInfoBloc(this._getPersonInfo) : super(PersonInfoLoading()) {
    on<PersonInfoLoadData>(_onLoadData);
  }

  void _onLoadData(
      PersonInfoLoadData event, Emitter<PersonInfoState> emit) async {
    try {
      emit(PersonInfoLoading());
      final personInfo = await _getPersonInfo();
      emit(PersonInfoLoaded(personInfo));
    } catch (e) {
      emit(PersonInfoError('Ошибка загрузки данных: ${e.toString()}'));
    }
  }
}
