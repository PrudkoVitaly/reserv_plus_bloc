import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;

class DocumentPdfGenerator {
  static Future<File> generatePdf({
    required String fullName,
    required String birthDate,
    required String status,
    required String validityDate,
    required String qrCode,
    required String lastUpdated,
  }) async {
    final pdf = pw.Document();
    
    // Используем встроенный шрифт с поддержкой кириллицы

    // Создаем улучшенный QR-код паттерн
    final qrImage = img.Image(width: 200, height: 200);
    
    // Заполняем белым фоном
    for (int x = 0; x < qrImage.width; x++) {
      for (int y = 0; y < qrImage.height; y++) {
        qrImage.setPixel(x, y, img.ColorRgb8(255, 255, 255));
      }
    }
    
    // Рисуем улучшенный QR-код паттерн
    for (int x = 0; x < 200; x += 10) {
      for (int y = 0; y < 200; y += 10) {
        if ((x + y) % 20 == 0 || (x - y) % 30 == 0) {
          for (int px = 0; px < 10; px++) {
            for (int py = 0; py < 10; py++) {
              if (x + px < 200 && y + py < 200) {
                qrImage.setPixel(x + px, y + py, img.ColorRgb8(0, 0, 0));
              }
            }
          }
        }
      }
    }
    
    // Добавляем угловые маркеры QR-кода
    _drawQrMarker(qrImage, 0, 0, 60);
    _drawQrMarker(qrImage, 140, 0, 60);
    _drawQrMarker(qrImage, 0, 140, 60);
    
    final qrImageBytes = img.encodePng(qrImage);
      
      // Создаем PDF страницу
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Container(
              padding: const pw.EdgeInsets.all(40),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Заголовок
                  pw.Container(
                    width: double.infinity,
                    padding: const pw.EdgeInsets.all(16),
                    decoration: pw.BoxDecoration(
                      color: PdfColor.fromHex('#FD870C'),
                      borderRadius: pw.BorderRadius.circular(8),
                    ),
                    child: pw.Text(
                      'ВІЙСЬКОВО-ОБЛІКОВИЙ ДОКУМЕНТ',
                      style: pw.TextStyle(
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.white,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                  
                  pw.SizedBox(height: 30),
                  
                  // Информация о документе
                  _buildInfoRow('ПІБ:', fullName),
                  pw.SizedBox(height: 12),
                  _buildInfoRow('Дата народження:', birthDate),
                  pw.SizedBox(height: 12),
                  _buildInfoRow('Статус:', status),
                  pw.SizedBox(height: 12),
                  _buildInfoRow('Дійсний до:', validityDate),
                  pw.SizedBox(height: 12),
                  _buildInfoRow('Оновлено:', lastUpdated),
                  
                  pw.SizedBox(height: 40),
                  
                  // QR-код
                  pw.Center(
                    child: pw.Container(
                      width: 200,
                      height: 200,
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(
                          color: PdfColors.black,
                          width: 3,
                        ),
                        borderRadius: pw.BorderRadius.circular(12),
                        boxShadow: [
                          pw.BoxShadow(
                            color: PdfColors.grey400,
                            offset: const PdfPoint(2, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: pw.Center(
                        child: pw.Image(
                          pw.MemoryImage(qrImageBytes),
                          width: 190,
                          height: 190,
                        ),
                      ),
                    ),
                  ),
                  
                  pw.Spacer(),
                  
                  // Футер
                  pw.Container(
                    width: double.infinity,
                    padding: const pw.EdgeInsets.all(12),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.grey200,
                      borderRadius: pw.BorderRadius.circular(8),
                    ),
                    child: pw.Text(
                      'Документ згенеровано додатком Резерв+\n${DateTime.now().toString().substring(0, 19)}',
                      style: const pw.TextStyle(
                        fontSize: 12,
                        color: PdfColors.grey700,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    // Сохраняем PDF в временную директорию
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/document_${DateTime.now().millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(await pdf.save());

    return file;
  }
  
  static void _drawQrMarker(img.Image image, int startX, int startY, int size) {
    // Внешний квадрат
    for (int x = startX; x < startX + size; x++) {
      for (int y = startY; y < startY + size; y++) {
        if (x < image.width && y < image.height) {
          image.setPixel(x, y, img.ColorRgb8(0, 0, 0));
        }
      }
    }
    
    // Внутренний белый квадрат
    for (int x = startX + 10; x < startX + size - 10; x++) {
      for (int y = startY + 10; y < startY + size - 10; y++) {
        if (x < image.width && y < image.height) {
          image.setPixel(x, y, img.ColorRgb8(255, 255, 255));
        }
      }
    }
    
    // Центральный черный квадрат
    for (int x = startX + 20; x < startX + size - 20; x++) {
      for (int y = startY + 20; y < startY + size - 20; y++) {
        if (x < image.width && y < image.height) {
          image.setPixel(x, y, img.ColorRgb8(0, 0, 0));
        }
      }
    }
  }

  static pw.Widget _buildInfoRow(String label, String value) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          width: 150,
          child: pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.grey800,
            ),
          ),
        ),
        pw.Expanded(
          child: pw.Text(
            value,
            style: const pw.TextStyle(
              fontSize: 14,
              color: PdfColors.black,
            ),
          ),
        ),
      ],
    );
  }
}

