import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'support_event.dart';
import 'support_state.dart';

class SupportBloc extends Bloc<SupportEvent, SupportState> {
  SupportBloc() : super(const SupportInitial()) {
    on<SupportInitialized>(_onInitialized);
    on<SupportCopyDeviceNumber>(_onCopyDeviceNumber);
    on<SupportOpenViber>(_onOpenViber);
  }

  void _onInitialized(
    SupportInitialized event,
    Emitter<SupportState> emit,
  ) {
    emit(const SupportLoaded());
  }

  void _onCopyDeviceNumber(
    SupportCopyDeviceNumber event,
    Emitter<SupportState> emit,
  ) async {
    emit(const SupportCopyingNumber());

    try {
      // Здесь можно получить реальный номер устройства
      const deviceNumber = '123456789'; // Заглушка

      await Clipboard.setData(ClipboardData(text: deviceNumber));

      emit(const SupportNumberCopied(
        message: 'Номер пристрою скопійовано',
      ));

      // Через 2 секунды возвращаемся к обычному состоянию
      await Future.delayed(const Duration(seconds: 2));
      emit(const SupportLoaded());
    } catch (e) {
      emit(SupportError(message: 'Помилка копіювання: ${e.toString()}'));
    }
  }

  void _onOpenViber(
    SupportOpenViber event,
    Emitter<SupportState> emit,
  ) async {
    emit(const SupportOpeningViber());

    try {
      const viberUrl = 'https://www.viber.com/ru/';

      // Копируем ссылку в буфер обмена
      await Clipboard.setData(ClipboardData(text: viberUrl));
      emit(const SupportViberOpened());
      await Future.delayed(const Duration(seconds: 1));
      emit(const SupportLoaded());
    } catch (e) {
      emit(SupportError(message: 'Помилка відкриття Viber: ${e.toString()}'));
    }
  }
}
