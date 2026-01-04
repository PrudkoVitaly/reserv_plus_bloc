import 'package:flutter/material.dart';
import 'package:reserv_plus/features/qr_scanner/presentation/pages/qr_scanner_page.dart';

class DocumentScanOptionsModal extends StatefulWidget {
  const DocumentScanOptionsModal({super.key});

  @override
  State<DocumentScanOptionsModal> createState() =>
      _DocumentScanOptionsModalState();
}

class _DocumentScanOptionsModalState extends State<DocumentScanOptionsModal> {
  double _dragStartY = 0.0;
  double _dragCurrentY = 0.0;
  double _dragOffset = 0.0;

  void _closeModal() {
    Navigator.of(context).pop();
  }

  void _openQRScanner(BuildContext context, String scanType) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const QRScannerPage(),
      ),
    );
  }

  void _handleDragStart(DragStartDetails details) {
    _dragStartY = details.globalPosition.dy;
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    _dragCurrentY = details.globalPosition.dy;
    double rawOffset = _dragCurrentY - _dragStartY;

    // Разрешаем только движение вниз (положительные значения)
    _dragOffset = rawOffset > 0 ? rawOffset : 0;

    setState(() {}); // Обновляем UI для следования за пальцем
  }

  void _handleDragEnd(DragEndDetails details) {
    double dragDistance = _dragCurrentY - _dragStartY;
    double velocity = details.primaryVelocity ?? 0;

    // Закрываем если перетащили вниз больше чем на 100 пикселей ИЛИ скорость больше 500
    if (dragDistance > 100 || velocity > 500) {
      _closeModal();
    } else {
      // Возвращаем контейнер в исходную позицию
      setState(() {
        _dragOffset = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 0.01),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          _closeModal(); // Закрываем модальное окно при клике вне контейнера
        },
        child: Center(
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1), // Начинаем снизу экрана
              end: const Offset(0, 0.45), // Заканчиваем ниже центра
            ).animate(CurvedAnimation(
              parent: ModalRoute.of(context)!.animation!,
              curve: Curves.easeInOut,
            )),
            child: Transform.translate(
              offset: Offset(0, _dragOffset), // Перемещаем контейнер за пальцем
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap:
                    () {}, // Пустой обработчик - блокируем клики на контейнере
                onPanStart: _handleDragStart, // Начало перетаскивания
                onPanUpdate: _handleDragUpdate, // Обновление позиции
                onPanEnd: _handleDragEnd, // Окончание перетаскивания
                child: Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.only(
                      top: 12, bottom: 12), // ⬅️ Убираем left и right padding
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 10),
                      // Ручка для перетаскивания
                      Container(
                        height: 5,
                        width: 45,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Який документ потрібно відсканувати?',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                  ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Divider(indent: 20),
                      _buildScanOption(
                        context,
                        'QR військово-облікового документа',
                        () => _openQRScanner(context, 'military'),
                      ),
                      _buildScanOption(
                        context,
                        'QR паперової повістки',
                        () => _openQRScanner(context, 'summons'),
                      ),
                      _buildScanOption(
                        context,
                        'QR направлення на ВЛК',
                        () => _openQRScanner(context, 'referral'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScanOption(
      BuildContext context, String title, VoidCallback onTap) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        _closeModal();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
        child: Row(
          children: [
            Image.asset(
              "images/scan_icon.png",
              width: 30,
              height: 30,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  height: 1.2,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
