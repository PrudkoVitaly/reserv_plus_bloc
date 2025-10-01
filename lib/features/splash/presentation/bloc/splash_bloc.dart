import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/splash_repository.dart';
import 'splash_event.dart';
import 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final SplashRepository _repository;

  SplashBloc({required SplashRepository repository})
      : _repository = repository,
        super(const SplashInitial()) {
    on<SplashStarted>(_onSplashStarted);
  }

  void _onSplashStarted(SplashStarted event, Emitter<SplashState> emit) async {
    emit(const SplashLoading());

    // Проверяем, нужно ли показывать splash
    final shouldShow = await _repository.shouldShowSplash();

    if (shouldShow) {
      // Получаем время загрузки из репозитория
      final duration = await _repository.getSplashDuration();
      await Future.delayed(duration);
    }

    emit(const SplashCompleted());
  }
}
