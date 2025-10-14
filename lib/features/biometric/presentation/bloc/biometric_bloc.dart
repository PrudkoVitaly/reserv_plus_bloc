import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reserv_plus/features/biometric/domain/repositories/biometric_repository.dart';
import 'package:reserv_plus/features/biometric/presentation/bloc/biometric_event.dart';
import 'package:reserv_plus/features/biometric/presentation/bloc/biometric_state.dart';

class BiometricBloc extends Bloc<BiometricEvent, BiometricState> {
  final BiometricRepository _repository;

  BiometricBloc({
    required BiometricRepository repository,
  })  : _repository = repository,
        super(const BiometricInitial()) {
    on<CheckBiometricStatusRequested>(_onCheckBiometricStatus);
    on<BiometricAuthenticationRequested>(_onAuthenticationRequested);
    on<BiometricSettingChanged>(_onSettingChanged);
  }

  Future<void> _onCheckBiometricStatus(
    CheckBiometricStatusRequested event,
    Emitter<BiometricState> emit,
  ) async {
    try {
      emit(const BiometricLoading());

      final status = await _repository.getBiometricStatus();

      emit(BiometricStatusLoaded(status: status));
    } catch (e) {
      emit(BiometricError(message: e.toString()));
    }
  }

  Future<void> _onAuthenticationRequested(
    BiometricAuthenticationRequested event,
    Emitter<BiometricState> emit,
  ) async {
    try {
      emit(const BiometricAuthenticating());

      final success = await _repository.authenticate();

      if (success) {
        emit(const BiometricAuthenticationSuccess());
      } else {
        emit(const BiometricAuthenticationFailure(
            message: 'Не вдалося пройти автентифікацію'));
      }
    } catch (e) {
      emit(BiometricError(message: e.toString()));
    }
  }

  Future<void> _onSettingChanged(
    BiometricSettingChanged event,
    Emitter<BiometricState> emit,
  ) async {
    try {
      await _repository.setBiometricEnabled(event.isEnabled);

      final status = await _repository.getBiometricStatus();
      emit(BiometricStatusLoaded(status: status));
    } catch (e) {
      emit(BiometricError(message: e.toString()));
    }
  }
}
