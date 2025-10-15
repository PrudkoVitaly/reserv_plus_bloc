import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:reserv_plus/features/qr_scanner/data/services/camera_service.dart';
import 'package:reserv_plus/features/qr_scanner/domain/entities/qr_scan_data.dart';
import 'package:reserv_plus/features/qr_scanner/domain/repositories/qr_scan_repository.dart';

class QRScanRepositoryImpl implements QRScanRepository {
  final CameraService _cameraService;
  MobileScannerController? _scannerController;
  QRScanData? _lastScanResult;

  QRScanRepositoryImpl({required CameraService cameraService})
      : _cameraService = cameraService;

  @override
  Future<void> startScanning() async {
    try {
      // Инициализируем камеру
      await _cameraService.initializeCamera();

      // Создаем контроллер сканера
      _scannerController = MobileScannerController(
        detectionSpeed: DetectionSpeed.normal,
        facing: CameraFacing.back,
        torchEnabled: false,
      );

      // Настраиваем обработчик результатов
      _scannerController!.barcodes.listen((BarcodeCapture capture) {
        final List<Barcode> barcodes = capture.barcodes;
        if (barcodes.isNotEmpty) {
          final barcode = barcodes.first;
          if (barcode.rawValue != null) {
            _lastScanResult = QRScanData(
              rawData: barcode.rawValue!,
              isValid: true,
              scanTime: DateTime.now(),
            );
          }
        }
      });
    } catch (e) {
      throw Exception('Ошибка инициализации сканера: ${e.toString()}');
    }
  }

  @override
  Future<void> stopScanning() async {
    _scannerController?.dispose();
    await _cameraService.dispose();
    _scannerController = null;
    _lastScanResult = null;
  }

  @override
  Future<QRScanData?> getScanResult() async {
    // Возвращаем последний результат сканирования
    return _lastScanResult;
  }

  // Получить контроллер сканера для UI
  MobileScannerController? get scannerController => _scannerController;
}
