import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/pin_repository.dart';
import 'pin_event.dart';
import 'pin_state.dart';

class PinBloc extends Bloc<PinEvent, PinState> {
  final PinRepository _repository;
  List<String> _enteredPin = [];

  PinBloc({required PinRepository repository})
      : _repository = repository,
        super(const PinInitial()) {
    on<PinStarted>(_onPinStarted);
    on<PinNumberPressed>(_onNumberPressed);
    on<PinDeletePressed>(_onDeletePressed);
    on<PinSubmitted>(_onSubmitted);
    on<PinBiometricsPressed>(_onBiometricsPressed);
    on<PinBiometricsCancelled>(_onBiometricsCancelled);
    on<PinReset>(_onPinReset);
  }

  void _onPinStarted(PinStarted event, Emitter<PinState> emit) async {
    final isBiometricsAvailable = await _repository.isBiometricsAvailable();
    emit(PinInitial(
      isBiometricsAvailable: isBiometricsAvailable,
      isBiometricsModalVisible:
          isBiometricsAvailable, // Показываем сразу, если биометрия доступна
    ));
  }

  void _onNumberPressed(PinNumberPressed event, Emitter<PinState> emit) {
    if (_enteredPin.length < 4) {
      _enteredPin.add(event.number);
      emit(PinEntering(
        enteredPin: List.from(_enteredPin),
        isBiometricsAvailable: state is PinInitial
            ? (state as PinInitial).isBiometricsAvailable
            : state is PinEntering
                ? (state as PinEntering).isBiometricsAvailable
                : false,
        isBiometricsModalVisible: false,
      ));

      // Автоматическая отправка при вводе 4 цифр с небольшой задержкой
      if (_enteredPin.length == 4) {
        Future.delayed(const Duration(milliseconds: 100), () {
          add(const PinSubmitted());
        });
      }
    }
  }

  void _onDeletePressed(PinDeletePressed event, Emitter<PinState> emit) {
    if (_enteredPin.isNotEmpty) {
      _enteredPin.removeLast();
      emit(PinEntering(
        enteredPin: List.from(_enteredPin),
        isBiometricsAvailable: state is PinInitial
            ? (state as PinInitial).isBiometricsAvailable
            : state is PinEntering
                ? (state as PinEntering).isBiometricsAvailable
                : false,
        isBiometricsModalVisible: false,
      ));
    }
  }

  void _onSubmitted(PinSubmitted event, Emitter<PinState> emit) async {
    if (_enteredPin.length == 4) {
      emit(const PinValidating());

      final pin = _enteredPin.join();
      final result = await _repository.validatePin(pin);

      if (result.isValid) {
        emit(const PinSuccess());
      } else {
        emit(PinError(
          message: result.errorMessage ?? 'Ошибка авторизации',
          enteredPin: List.from(_enteredPin),
          isBiometricsAvailable: state is PinEntering
              ? (state as PinEntering).isBiometricsAvailable
              : false,
        ));
        _enteredPin.clear();
        // Возвращаемся к состоянию ввода
        final isBiometricsAvailable = await _repository.isBiometricsAvailable();
        emit(PinEntering(
          enteredPin: _enteredPin,
          isBiometricsAvailable: isBiometricsAvailable,
        ));
      }
    }
  }

  void _onBiometricsPressed(
      PinBiometricsPressed event, Emitter<PinState> emit) async {
    // Показываем модальное окно биометрии
    emit(PinEntering(
      enteredPin: _enteredPin,
      isBiometricsAvailable: state is PinInitial
          ? (state as PinInitial).isBiometricsAvailable
          : state is PinEntering
              ? (state as PinEntering).isBiometricsAvailable
              : false,
      isBiometricsModalVisible: true,
    ));

    // Имитация задержки для показа модального окна
    await Future.delayed(const Duration(milliseconds: 500));

    final result = await _repository.authenticateWithBiometrics();

    if (result.isValid) {
      emit(const PinSuccess());
    } else {
      emit(PinError(
        message: result.errorMessage ?? 'Ошибка биометрической аутентификации',
        enteredPin: List.from(_enteredPin),
        isBiometricsAvailable: state is PinInitial
            ? (state as PinInitial).isBiometricsAvailable
            : state is PinEntering
                ? (state as PinEntering).isBiometricsAvailable
                : false,
        isBiometricsModalVisible: false,
      ));
    }
  }

  void _onBiometricsCancelled(
      PinBiometricsCancelled event, Emitter<PinState> emit) {
    final isBiometricsAvailable = state is PinInitial
        ? (state as PinInitial).isBiometricsAvailable
        : state is PinEntering
            ? (state as PinEntering).isBiometricsAvailable
            : false;
    emit(PinEntering(
      enteredPin: _enteredPin,
      isBiometricsAvailable: isBiometricsAvailable,
      isBiometricsModalVisible: false,
    ));
  }

  void _onPinReset(PinReset event, Emitter<PinState> emit) {
    _enteredPin.clear();
    final isBiometricsAvailable = state is PinInitial
        ? (state as PinInitial).isBiometricsAvailable
        : state is PinEntering
            ? (state as PinEntering).isBiometricsAvailable
            : false;
    emit(PinEntering(
      enteredPin: _enteredPin,
      isBiometricsAvailable: isBiometricsAvailable,
      isBiometricsModalVisible: false,
    ));
  }
}
