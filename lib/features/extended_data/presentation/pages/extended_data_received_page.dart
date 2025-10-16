import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
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
        padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 26.0),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 170,
                      height: 170,
                      child: Image.asset(
                        "images/get_data_image.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Отримали дані з реєстру',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        height: 1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Запит можна подавати раз на 24 години',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        height: 1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    // Опция скачивания файла
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: GestureDetector(
                          onTap: () => _downloadPDF(context),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                "images/download_image.png",
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'Завантажити файл',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
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
