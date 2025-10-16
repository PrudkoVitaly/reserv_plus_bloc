import 'package:flutter/material.dart';
import 'extended_data_received_page.dart';
import '../../data/services/extended_data_pdf_generator.dart';
import '../../domain/entities/extended_data.dart';

class ExtendedDataSuccessPage extends StatelessWidget {
  const ExtendedDataSuccessPage({super.key});

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
                    // Иконка щита с восклицательным знаком
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
                      child: const Icon(
                        Icons.security,
                        size: 60,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      'Запит надіслано',
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
                      'Тепер слід трохи почекати',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        height: 1.3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () async {
                  // Генерируем PDF и переходим к финальному экрану
                  try {
                    final data = ExtendedData.fromUserData();
                    final pdfPath =
                        await ExtendedDataPdfGenerator.generateExtendedDataPDF(
                            data);

                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => ExtendedDataReceivedPage(
                          pdfPath: pdfPath,
                        ),
                      ),
                    );
                  } catch (e) {
                    // Если ошибка, переходим без PDF
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const ExtendedDataReceivedPage(),
                      ),
                    );
                  }
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
}
