import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:reserv_plus/features/qr_scanner/data/repositories/qr_scan_repository_impl.dart';
import 'package:reserv_plus/features/qr_scanner/data/services/camera_service.dart';
import 'package:reserv_plus/features/qr_scanner/domain/entities/qr_scan_data.dart';
import 'package:reserv_plus/features/qr_scanner/presentation/bloc/qr_scanner_bloc.dart';
import 'package:reserv_plus/features/qr_scanner/presentation/bloc/qr_scanner_event.dart';
import 'package:reserv_plus/features/qr_scanner/presentation/bloc/qr_scanner_state.dart';
import 'package:reserv_plus/features/shared/presentation/widgets/delayed_loading_indicator.dart';

class QRScannerPage extends StatelessWidget {
  const QRScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QRScannerBloc(
        repository: QRScanRepositoryImpl(
          cameraService: CameraService(),
        ),
      )..add(const QRScannerInitialized()),
      child: const QRScannerView(),
    );
  }
}

class QRScannerView extends StatefulWidget {
  const QRScannerView({super.key});

  @override
  State<QRScannerView> createState() => _QRScannerViewState();
}

class _QRScannerViewState extends State<QRScannerView> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playSuccessSound() async {
    try {
      // Воспроизводим системный звук + вибрация
      await HapticFeedback.heavyImpact(); // Вибрация

      // Воспроизводим звук из локального файла
      // Используем BytesSource для прямого воспроизведения
      await _audioPlayer.setVolume(1.0); // Максимальная громкость
      await _audioPlayer.play(
        BytesSource(
          // Простой beep звук в base64 (очень короткий WAV)
          Uint8List.fromList([
            82,
            73,
            70,
            70,
            36,
            0,
            0,
            0,
            87,
            65,
            86,
            69,
            102,
            109,
            116,
            32,
            16,
            0,
            0,
            0,
            1,
            0,
            1,
            0,
            68,
            172,
            0,
            0,
            136,
            88,
            1,
            0,
            2,
            0,
            16,
            0,
            100,
            97,
            116,
            97,
            0,
            0,
            0,
            0
          ]),
        ),
      );

      print('✅ Звук и вибрация успешно воспроизведены');
    } catch (e) {
      print('❌ Ошибка воспроизведения звука: $e');
      // Хотя бы вибрация сработает
      try {
        await HapticFeedback.heavyImpact();
      } catch (_) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocListener<QRScannerBloc, QRScannerState>(
        listener: (context, state) {
          // Автоматически закрываем сканер через 2 секунды после успеха
          if (state is QRScannerSuccess) {
            _playSuccessSound();
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) {
                Navigator.of(context).pop(state.result);
              }
            });
          }
        },
        child: BlocBuilder<QRScannerBloc, QRScannerState>(
          builder: (context, state) {
            if (state is QRScannerLoading) {
              return const DelayedLoadingIndicator();
            }
            if (state is QRScannerReady) {
              return _buildScannerUI(context);
            }

            if (state is QRScannerScanning) {
              return _buildScannerUI(context);
            }

            if (state is QRScannerSuccess) {
              return _buildSuccessUI(context, state.result);
            }

            if (state is QRScannerFailure) {
              return _buildErrorUI(context, state.error);
            }

            return const Center(
              child: Text('Неизвестное состояние',
                  style: TextStyle(color: Colors.white)),
            );
          },
        ),
      ),
    );
  }

  // UI для сканирования - реальная камера с рамкой
  Widget _buildScannerUI(BuildContext context) {
    return BlocBuilder<QRScannerBloc, QRScannerState>(
      builder: (context, state) {
        final repository =
            context.read<QRScannerBloc>().repository as QRScanRepositoryImpl;
        final scannerController = repository.scannerController;

        if (scannerController == null) {
          return const Center(
            child: Text('Сканер не инициализирован',
                style: TextStyle(color: Colors.white)),
          );
        }

        return Stack(
          children: [
            // Реальная камера
            MobileScanner(
              controller: scannerController,
              onDetect: (BarcodeCapture capture) {
                // Обрабатываем результат сканирования
                final List<Barcode> barcodes = capture.barcodes;
                if (barcodes.isNotEmpty) {
                  final barcode = barcodes.first;
                  if (barcode.rawValue != null) {
                    // Создаем QRScanData и передаем в BLoC
                    final scanData = QRScanData(
                      rawData: barcode.rawValue!,
                      isValid: true,
                      scanTime: DateTime.now(),
                    );

                    // Эмитим успешное состояние с результатом
                    context
                        .read<QRScannerBloc>()
                        .add(QRScannerResultReceived(result: scanData));
                  }
                }
              },
            ),

            // Темный overlay сверху
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                ),
                child: const Center(
                  child: Text(
                    'Сканування',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ),

            // Кнопка закрытия
            Positioned(
              top: 50,
              right: 20,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),

            // Рамка для сканирования
            Center(
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            // Инструкция
            Positioned(
              bottom: 100,
              left: 20,
              right: 20,
              child: Text(
                'Наведіть рамку на QR-код, який хочете відсканувати.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
      },
    );
  }

  // UI для успешного сканирования
  Widget _buildSuccessUI(BuildContext context, result) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.green.shade900,
            Colors.black,
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Анимированная галочка
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 600),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.green.shade400,
                    size: 120,
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
            const Text(
              'QR-код успішно відскановано!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            // Информативная карточка с данными
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.green.shade400,
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.qr_code_2,
                    color: Colors.white,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Отримані дані:',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    result.rawData.length > 100
                        ? '${result.rawData.substring(0, 100)}...'
                        : result.rawData,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // Прогресс индикатор автоматического закрытия
            const Column(
              children: [
                SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white54),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Автоматичне повернення...',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // UI для ошибки
  Widget _buildErrorUI(BuildContext context, String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, color: Colors.red, size: 100),
          const SizedBox(height: 20),
          Text(
            'Ошибка: $error',
            style: const TextStyle(color: Colors.white, fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }
}
