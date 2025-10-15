import 'package:reserv_plus/features/qr_scanner/domain/entities/qr_scan_data.dart';

abstract class QRScanRepository {
  Future<void> startScanning();
  Future<void> stopScanning();
  Future<QRScanData?> getScanResult();
}
