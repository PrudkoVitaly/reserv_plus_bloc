import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reserv_plus/features/forgot_pin/domain/entities/forgot_pin_data.dart';
import 'package:reserv_plus/features/forgot_pin/domain/repositories/forgot_pin_repository.dart';
import 'package:reserv_plus/features/forgot_pin/presentation/bloc/forgot_pin_event.dart';
import 'package:reserv_plus/features/forgot_pin/presentation/bloc/forgot_pin_state.dart';

class ForgotPinBloc extends Bloc<ForgotPinEvent, ForgotPinState> {
  final ForgotPinRepository _repository;

  ForgotPinBloc({required ForgotPinRepository repository})
      : _repository = repository,
        super(ForgotPinInitial()) {
    on<ForgotPinInitialized>(_onInitialized);
    on<ForgotPinAuthorizePressed>(_onAuthorizePressed);
    on<ForgotPinCancelPressed>(_onCancelPressed);
  }

  // Загружает данные экрана
  Future<void> _onInitialized(
    ForgotPinInitialized event,
    Emitter<ForgotPinState> emit,
  ) async {
    emit(const ForgotPinLoading(
      data: ForgotPinData(
        title: '',
        description: '',
        authorizeButtonText: '',
        cancelButtonText: '',
      ),
    ));

    try {
      final data = await _repository.getForgotPinData();
      emit(ForgotPinLoaded(data: data));
    } catch (e) {
      emit(ForgotPinAuthorizationFailure(error: e.toString()));
    }
  }

  // Обрабатывает нажатие кнопки авторизации и загружает данные
  Future<void> _onAuthorizePressed(
    ForgotPinAuthorizePressed event,
    Emitter<ForgotPinState> emit,
  ) async {
    if (state is ForgotPinLoaded) {
      final currentData = (state as ForgotPinLoaded).data;

      emit(ForgotPinAuthorizationInProgress(data: currentData));

      try {
        await _repository.requestReAuthorization();
        emit(ForgotPinAuthorizationSuccess());
      } catch (e) {
        emit(const ForgotPinAuthorizationFailure(
            error: 'Авторизація не вдалася'));
      }
    }
  }

  // Просто возвращаемся к начальному состоянию
  void _onCancelPressed(
    ForgotPinCancelPressed event,
    Emitter<ForgotPinState> emit,
  ) {
    emit(ForgotPinInitial());
  }
}
