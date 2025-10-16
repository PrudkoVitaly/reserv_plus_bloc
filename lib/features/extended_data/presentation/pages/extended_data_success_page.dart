import 'package:flutter/material.dart';
import 'package:reserv_plus/shared/utils/navigation_utils.dart';
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
        padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Иконка щита с восклицательным знаком
                    SizedBox(
                      width: 160,
                      height: 160,
                      child: Image.asset(
                        "images/attention_image.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 20),
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
                        fontWeight: FontWeight.w500,
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

                    if (!context.mounted) return;

                    NavigationUtils.pushWithHorizontalAnimation(
                      context: context,
                      page: ExtendedDataReceivedPage(pdfPath: pdfPath),
                    ).then((_) {
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    });
                  } catch (e) {
                    // Если ошибка, переходим без PDF
                    if (!context.mounted) return;

                    NavigationUtils.pushWithHorizontalAnimation(
                      context: context,
                      page: const ExtendedDataReceivedPage(),
                    ).then((_) {
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    });
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
