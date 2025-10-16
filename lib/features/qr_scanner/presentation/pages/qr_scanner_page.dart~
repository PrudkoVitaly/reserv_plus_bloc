import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter/services.dart';
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
  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _playSuccessSound() async {
    try {
      // Вибрация
      await HapticFeedback.heavyImpact();
      await HapticFeedback.mediumImpact();

      // Звук успеха - несколько вариантов
      await _playBeepSound();
    } catch (e) {}
  }

  Future<void> _playBeepSound() async {
    try {
      // Попробуем разные системные звуки
      await SystemSound.play(SystemSoundType.click);
    } catch (e) {
      try {
        await SystemSound.play(SystemSoundType.alert);
      } catch (e2) {
        // Только вибрация
        await HapticFeedback.heavyImpact();
      }
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
            Future.delayed(const Duration(seconds: 3), () {
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

  // UI для сканирования - реальная камера с темно-серым фоном и угловыми маркерами
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

            // Темно-серый фон с вырезанной областью для сканирования
            CustomPaint(
              painter: ScannerOverlayPainter(),
              size: Size.infinite,
            ),

            // Заголовок и кнопка закрытия
            Positioned(
              top: 10,
              left: 0,
              right: 0,
              child: Container(
                height: 100,
                child: Stack(
                  children: [
                    // Заголовок по центру всего экрана
                    const Center(
                      child: Text(
                        'Сканування',
                        style: TextStyle(color: Colors.white, fontSize: 22),
                      ),
                    ),
                    // Кнопка закрытия справа
                    Positioned(
                      top: 0,
                      right: 30,
                      bottom: 0,
                      child: Center(
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Инструкция выше рамки
            const Positioned(
              top: 100,
              left: 20,
              right: 20,
              child: const Text(
                'Наведіть рамку на QR-код, який хочете відсканувати.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // Рамка для сканирования с угловыми маркерами
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width *
                    0.7, // 70% от ширины экрана
                height: MediaQuery.of(context).size.width *
                    0.7, // Квадрат по ширине

                child: Stack(
                  children: [
                    // Угловые маркеры
                    _buildCornerMarker(Alignment.topLeft),
                    _buildCornerMarker(Alignment.topRight),
                    _buildCornerMarker(Alignment.bottomLeft),
                    _buildCornerMarker(Alignment.bottomRight),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Создание угловых маркеров
  Widget _buildCornerMarker(Alignment alignment) {
    return Positioned.fill(
      child: Align(
        alignment: alignment,
        child: CustomPaint(
          size: const Size(30, 30),
          painter: CornerMarkerPainter(alignment: alignment),
        ),
      ),
    );
  }

  // UI для успешного сканирования
  Widget _buildSuccessUI(BuildContext context, result) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: Color.fromRGBO(226, 223, 204, 1),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Анимированная галочка
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 500),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: const Icon(
                    Icons.check_circle,
                    color: Colors.orange,
                    size: 120,
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
            const Text(
              'QR-код успішно відскановано!',
              style: TextStyle(
                color: Colors.black,
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
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.orange,
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.qr_code_2,
                    color: Colors.black,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Отримані дані:',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    result.rawData.length > 100
                        ? '${result.rawData.substring(0, 100)}...'
                        : result.rawData,
                    style: const TextStyle(
                      color: Colors.black,
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
                DelayedLoadingIndicator(),
                SizedBox(height: 12),
                Text(
                  'Автоматичне повернення...',
                  style: TextStyle(
                    color: Colors.black54,
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

// Кастомный painter для создания маски с вырезанной областью сканирования
class ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF2C2C2C).withOpacity(0.6)
      ..style = PaintingStyle.fill;

    // Создаем путь для всей области
    final path = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // Вырезаем прямоугольную область в центре - ДИНАМИЧЕСКИЙ РАЗМЕР
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final scanAreaSize = size.width * 0.7;

    final scanRect = Rect.fromCenter(
      center: Offset(centerX, centerY),
      width: scanAreaSize,
      height: scanAreaSize,
    );

    // Создаем путь для вырезанной области
    final scanPath = Path()
      ..addRRect(RRect.fromRectAndRadius(scanRect, const Radius.circular(12)));

    // Объединяем пути (вычитаем область сканирования)
    final combinedPath = Path.combine(PathOperation.difference, path, scanPath);

    canvas.drawPath(combinedPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Кастомный painter для L-образных углов
class CornerMarkerPainter extends CustomPainter {
  final Alignment alignment;

  CornerMarkerPainter({required this.alignment});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final cornerRadius = 16.0;
    final lineLength = 20.0;

    if (alignment == Alignment.topLeft) {
      // Левый верхний угол - длинный
      path.moveTo(0, lineLength);
      path.lineTo(0, cornerRadius);
      path.quadraticBezierTo(0, 0, cornerRadius, 0);
      path.lineTo(lineLength, 0);
    } else if (alignment == Alignment.topRight) {
      // Правый верхний угол - длинный
      path.moveTo(size.width - lineLength, 0);
      path.lineTo(size.width - cornerRadius, 0);
      path.quadraticBezierTo(size.width, 0, size.width, cornerRadius);
      path.lineTo(size.width, lineLength);
    } else if (alignment == Alignment.bottomLeft) {
      // Левый нижний угол - длинный
      path.moveTo(0, size.height - lineLength);
      path.lineTo(0, size.height - cornerRadius);
      path.quadraticBezierTo(0, size.height, cornerRadius, size.height);
      path.lineTo(lineLength, size.height);
    } else if (alignment == Alignment.bottomRight) {
      // Правый нижний угол - длинный
      path.moveTo(size.width - lineLength, size.height);
      path.lineTo(size.width - cornerRadius, size.height);
      path.quadraticBezierTo(
          size.width, size.height, size.width, size.height - cornerRadius);
      path.lineTo(size.width, size.height - lineLength);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
