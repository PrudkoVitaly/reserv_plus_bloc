import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reserv_plus/features/qr_scanner/domain/repositories/qr_scan_repository.dart';
import 'qr_scanner_event.dart';
import 'qr_scanner_state.dart';

class QRScannerBloc extends Bloc<QRScannerEvent, QRScannerState> {
  final QRScanRepository _repository;
  QRScanRepository get repository => _repository;

  QRScannerBloc({required QRScanRepository repository})
      : _repository = repository,
        super(const QRScannerInitial()) {
    on<QRScannerInitialized>(_onInitialized);
    on<QRScannerStarted>(_onStarted);
    on<QRScannerStopped>(_onStopped);
    on<QRScannerResultReceived>(_onQRScannerSuccess);
  }

  Future<void> _onInitialized(
    QRScannerInitialized event,
    Emitter<QRScannerState> emit,
  ) async {
    emit(const QRScannerLoading());

    try {
      await _repository.startScanning();
      emit(const QRScannerReady());
    } catch (e) {
      emit(QRScannerFailure(error: e.toString()));
    }
  }

  Future<void> _onStarted(
    QRScannerStarted event,
    Emitter<QRScannerState> emit,
  ) async {
    emit(const QRScannerScanning());

    try {
      final result = await _repository.getScanResult();
      if (result != null) {
        emit(QRScannerSuccess(result: result));
      }
    } catch (e) {
      emit(QRScannerFailure(error: e.toString()));
    }
  }

  Future<void> _onStopped(
    QRScannerStopped event,
    Emitter<QRScannerState> emit,
  ) async {
    await _repository.stopScanning();
    emit(const QRScannerInitial());
  }

  Future<void> _onQRScannerSuccess(
    QRScannerResultReceived event,
    Emitter<QRScannerState> emit,
  ) async {
    // Эмитим успешное состояние с результатом
    emit(QRScannerSuccess(result: event.result));
  }
}
