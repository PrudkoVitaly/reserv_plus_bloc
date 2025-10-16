import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:cross_file/cross_file.dart';
import '../../data/services/extended_data_pdf_generator.dart';
import '../../domain/entities/extended_data.dart';

class ExtendedDataReceivedPage extends StatelessWidget {
  final String? pdfPath;

  const ExtendedDataReceivedPage({super.key, this.pdfPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(226, 223, 204, 1),
      body: Padding(
        padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 34.0),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Иконка успеха - круг с квадратом и стрелкой
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.black,
                            width: 3,
                          ),
                        ),
                        child: const Icon(
                          Icons.arrow_forward,
                          size: 40,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      'Отримали дані з реєстру',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Запит можна подавати раз на 24 години',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        height: 1.3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    // Опция скачивания файла
                    GestureDetector(
                      onTap: () => _downloadPDF(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(color: Colors.orange.withOpacity(0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.download,
                              color: Colors.black,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Завантажити файл',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                ),
                child: const Text(
                  'Зрозуміло',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _downloadPDF(BuildContext context) async {
    try {
      if (pdfPath != null) {
        final file = File(pdfPath!);
        if (await file.exists()) {
          // Показываем диалог выбора действия
          await Share.shareXFiles(
            [XFile(pdfPath!)],
            text: 'Розширені дані з реєстру',
          );
        } else {
          // Если PDF не существует, генерируем новый
          await _generateAndSharePDF(context);
        }
      } else {
        // Если путь не передан, генерируем новый PDF
        await _generateAndSharePDF(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Помилка: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _generateAndSharePDF(BuildContext context) async {
    try {
      // Показываем индикатор загрузки
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Генеруємо PDF...'),
          backgroundColor: Colors.orange,
        ),
      );

      // Генерируем PDF
      final data = ExtendedData.fromUserData();
      final newPdfPath =
          await ExtendedDataPdfGenerator.generateExtendedDataPDF(data);

      // Показываем диалог выбора действия
      await Share.shareXFiles(
        [XFile(newPdfPath)],
        text: 'Розширені дані з реєстру',
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Помилка генерації PDF: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
