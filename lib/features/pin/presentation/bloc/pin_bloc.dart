import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/pin_repository.dart';
import 'pin_event.dart';
import 'pin_state.dart';

class PinBloc extends Bloc<PinEvent, PinState> {
  final PinRepository _repository;
  final List<String> _enteredPin = [];

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

  /// Получить текущее значение isBiometricsAvailable из любого состояния
  bool _getBiometricsAvailable() {
    final currentState = state;
    if (currentState is PinInitial) {
      return currentState.isBiometricsAvailable;
    } else if (currentState is PinEntering) {
      return currentState.isBiometricsAvailable;
    } else if (currentState is PinShaking) {
      return currentState.isBiometricsAvailable;
    } else if (currentState is PinError) {
      return currentState.isBiometricsAvailable;
    }
    return false;
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
        isBiometricsAvailable: _getBiometricsAvailable(),
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

  void _onDeletePressed(PinDeletePressed event, Emitter<PinState> emit) async {
    if (_enteredPin.isNotEmpty) {
      final isBiometricsAvailable = _getBiometricsAvailable();

      // Сначала показываем анимацию дрожания
      emit(PinShaking(
        enteredPin: List.from(_enteredPin),
        isBiometricsAvailable: isBiometricsAvailable,
        isBiometricsModalVisible: false,
      ));

      // Ждем завершения анимации
      await Future.delayed(const Duration(milliseconds: 400));

      // Затем очищаем PIN
      _enteredPin.clear();
      emit(PinEntering(
        enteredPin: List.from(_enteredPin),
        isBiometricsAvailable: isBiometricsAvailable,
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
      isBiometricsAvailable: _getBiometricsAvailable(),
      isBiometricsModalVisible: true,
    ));

    // Модальное окно остается открытым до ручного закрытия через кнопку "Скасувати"
    // Никакого автоматического закрытия!
  }

  void _onBiometricsCancelled(
      PinBiometricsCancelled event, Emitter<PinState> emit) {
    emit(PinEntering(
      enteredPin: _enteredPin,
      isBiometricsAvailable: _getBiometricsAvailable(),
      isBiometricsModalVisible: false,
    ));
  }

  void _onPinReset(PinReset event, Emitter<PinState> emit) {
    _enteredPin.clear();
    emit(PinEntering(
      enteredPin: _enteredPin,
      isBiometricsAvailable: _getBiometricsAvailable(),
      isBiometricsModalVisible: false,
    ));
  }
}
