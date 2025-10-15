import 'package:equatable/equatable.dart';
import '../../domain/entities/qr_scan_data.dart';

abstract class QRScannerState extends Equatable {
  const QRScannerState();

  @override
  List<Object?> get props => [];
}

class QRScannerInitial extends QRScannerState {
  const QRScannerInitial();
}

class QRScannerLoading extends QRScannerState {
  const QRScannerLoading();
}

class QRScannerReady extends QRScannerState {
  const QRScannerReady();
}

class QRScannerScanning extends QRScannerState {
  const QRScannerScanning();
}

class QRScannerSuccess extends QRScannerState {
  final QRScanData result;

  const QRScannerSuccess({required this.result});

  @override
  List<Object?> get props => [result];
}

class QRScannerFailure extends QRScannerState {
  final String error;

  const QRScannerFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
