import 'package:flutter/material.dart';
import 'modal_container_widget.dart';
import 'modal_widget.dart';
import 'bottom_sheet_modal.dart';
import 'alert_modal.dart';

class ModalExamples extends StatelessWidget {
  const ModalExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modal Examples'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Приклади використання модальних компонентів',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Простой контейнер
            const ModalContainerWidget(
              text: 'Простий контейнер',
            ),

            const SizedBox(height: 20),

            // Контейнер с кастомными стилями
            ModalContainerWidget(
              text: 'Кастомний контейнер',
              backgroundColor: Colors.blue[50],
              textColor: Colors.blue[800],
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),

            const SizedBox(height: 20),

            // Кнопки для демонстрации модальных окон
            ElevatedButton(
              onPressed: () => _showModalDialog(context),
              child: const Text('Показати Modal Dialog'),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () => _showBottomSheet(context),
              child: const Text('Показати Bottom Sheet'),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () => _showAlert(context),
              child: const Text('Показати Alert'),
            ),
          ],
        ),
      ),
    );
  }

  void _showModalDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const ModalWidget(
        title: 'Модальне вікно',
        content: 'Це приклад модального вікна з чистою архітектурою!',
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const BottomSheetModal(
        title: 'Bottom Sheet',
        content: Text('Це приклад bottom sheet з чистою архітектурою!'),
      ),
    );
  }

  void _showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AlertModal(
        title: 'Увага!',
        message: 'Це приклад alert з чистою архітектурою!',
        icon: Icons.warning,
        iconColor: Colors.orange,
        confirmText: 'Зрозуміло',
        cancelText: 'Скасувати',
      ),
    );
  }
}
