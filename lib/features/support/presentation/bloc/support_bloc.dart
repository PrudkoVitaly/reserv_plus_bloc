import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/support_repository.dart';
import 'support_event.dart';
import 'support_state.dart';

class SupportBloc extends Bloc<SupportEvent, SupportState> {
  final SupportRepository _repository;
  SupportBloc({
    required SupportRepository repository,
  })  : _repository = repository,
        super(const SupportInitial()) {
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
      final deviceNumber = await _repository.getDeviceNumber();

      await _repository.copyToClipboard(deviceNumber);

      emit(const SupportNumberCopied(
        message: 'Номер пристрою скопійовано',
      ));

      await Future.delayed(const Duration(seconds: 2));
      emit(const SupportLoaded());
    } catch (e) {
      emit(SupportError(message: e.toString()));
    }
  }

  void _onOpenViber(
    SupportOpenViber event,
    Emitter<SupportState> emit,
  ) async {
    emit(const SupportOpeningViber());

    try {
      final viberUrl = await _repository.getViberUrl();

      await _repository.openUrl(viberUrl);

      emit(const SupportViberOpened());

      await Future.delayed(const Duration(seconds: 1));
      emit(const SupportLoaded());
    } catch (e) {
      emit(SupportError(message: e.toString()));
    }
  }
}
