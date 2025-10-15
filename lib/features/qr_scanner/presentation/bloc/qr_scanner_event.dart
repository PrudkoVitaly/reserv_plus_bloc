import 'package:equatable/equatable.dart';
import 'package:reserv_plus/features/qr_scanner/domain/entities/qr_scan_data.dart';

abstract class QRScannerEvent extends Equatable {
  const QRScannerEvent();

  @override
  List<Object?> get props => [];
}

class QRScannerInitialized extends QRScannerEvent {
  const QRScannerInitialized();
}

class QRScannerStarted extends QRScannerEvent {
  const QRScannerStarted();
}

class QRScannerStopped extends QRScannerEvent {
  const QRScannerStopped();
}

class QRScannerResultReceived extends QRScannerEvent {
  final QRScanData result;

  const QRScannerResultReceived({required this.result});

  @override
  List<Object?> get props => [result];
}

class QRScannerError extends QRScannerEvent {
  const QRScannerError();
}
