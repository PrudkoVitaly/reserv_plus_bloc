import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import '../../data/services/extended_data_pdf_generator.dart';
import '../../domain/entities/extended_data.dart';
import 'package:reserv_plus/features/shared/presentation/widgets/primary_button.dart';

class ExtendedDataReceivedPage extends StatefulWidget {
  final String? pdfPath;

  const ExtendedDataReceivedPage({super.key, this.pdfPath});

  @override
  State<ExtendedDataReceivedPage> createState() =>
      _ExtendedDataReceivedPageState();
}

class _ExtendedDataReceivedPageState extends State<ExtendedDataReceivedPage> {
  String? _cachedPdfPath;

  @override
  void initState() {
    super.initState();
    _preGeneratePDF();
  }

  Future<void> _preGeneratePDF() async {
    if (widget.pdfPath != null) {
      final file = File(widget.pdfPath!);
      if (await file.exists()) {
        _cachedPdfPath = widget.pdfPath;
        return;
      }
    }
    // Генерируем PDF заранее
    try {
      final data = ExtendedData.fromUserData();
      _cachedPdfPath =
          await ExtendedDataPdfGenerator.generateExtendedDataPDF(data);
    } catch (e) {
      // Игнорируем ошибку, попробуем сгенерировать при клике
    }
  }

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
                        fontWeight: FontWeight.w500,
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
                          onTap: _sharePDF,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                "images/download_file.png",
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
            PrimaryButton(
              text: 'Зрозуміло',
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sharePDF() async {
    try {
      // Если PDF уже сгенерирован - сразу шарим
      if (_cachedPdfPath != null) {
        final file = File(_cachedPdfPath!);
        if (await file.exists()) {
          await Share.shareXFiles(
            [XFile(_cachedPdfPath!)],
            text: 'Розширені дані з реєстру',
          );
          return;
        }
      }

      // Если нет - генерируем и шарим
      final data = ExtendedData.fromUserData();
      final newPdfPath =
          await ExtendedDataPdfGenerator.generateExtendedDataPDF(data);
      _cachedPdfPath = newPdfPath;

      await Share.shareXFiles(
        [XFile(newPdfPath)],
        text: 'Розширені дані з реєстру',
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Помилка: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
