import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:reserv_plus/features/extended_data/domain/entities/extended_data.dart';
import 'package:reserv_plus/features/shared/services/user_data_service.dart';

class ExtendedDataPdfGenerator {
  static Future<String> generateExtendedDataPDF(ExtendedData data) async {
    final pdf = pw.Document();

    // Используем системный шрифт для поддержки украинского языка
    final ttf = pw.Font.helvetica();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(20),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Заголовок
              _buildHeader(ttf),
              pw.SizedBox(height: 20),

              // Основная информация
              _buildMainInfoCard(data, ttf),
              pw.SizedBox(height: 15),

              // Контактные данные
              _buildContactInfoCard(data, ttf),
            ],
          );
        },
      ),
    );

    // Сохраняем PDF
    final directory = Directory.systemTemp;
    final fileName =
        'extended_data_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(await pdf.save());

    return file.path;
  }

  static pw.Widget _buildHeader(pw.Font font) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(20),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Розширені дані з Єдиного державного реєстру призовників, військовозобов\'язаних та резервістів',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.grey800,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'Резерв+',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.grey800,
                ),
              ),
              pw.Text(
                'Сформовано: ${_getCurrentDateTime()}',
                style: const pw.TextStyle(
                  fontSize: 12,
                  color: PdfColors.grey600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildMainInfoCard(ExtendedData data, pw.Font font) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(20),
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Имя
          pw.Text(
            data.fullName.toUpperCase(),
            style: pw.TextStyle(
              fontSize: 20,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.grey800,
            ),
          ),
          pw.SizedBox(height: 15),

          // Личные данные
          _buildInfoRow('Дата народження', data.birthDate, font),
          _buildInfoRow('Стать', data.gender, font),
          _buildInfoRow('РНОКПП', data.taxId, font),
          pw.SizedBox(height: 10),

          // Военный учет
          _buildInfoRow('Категорія обліку', data.status, font),
          _buildInfoRow('Відстрочка до', '—', font),
          _buildInfoRow('Тип відстрочки', '—', font),
          pw.SizedBox(height: 10),

          // Основание исключения
          pw.Text(
            'Підстава зняття/виключення: (п. 3 ч. 6 ст. 37) визнані непридатними до військової служби',
            style: const pw.TextStyle(
              fontSize: 12,
              color: PdfColors.grey700,
            ),
          ),
          pw.SizedBox(height: 10),

          // Место рождения
          _buildInfoRow('Місце народження', data.placeOfBirth, font),
          pw.SizedBox(height: 10),

          // ТЦК и СП
          _buildInfoRow(
              'ТЦК та СП',
              'Амур-Нижньодніпровський районний у місті Дніпро ТЦК та СП',
              font),
          pw.SizedBox(height: 10),

          // ВЛК данные
          _buildInfoRow('Дата взяття на облік', UserDataService().vlkDate, font),
          _buildInfoRow('Дата ВЛК', UserDataService().vlkDate, font),
          _buildInfoRow('Номер протоколу ВЛК', UserDataService().vlkProtocolNumber, font),
          _buildInfoRow('Постанова ВЛК', UserDataService().vlkResolution, font),
        ],
      ),
    );
  }

  static pw.Widget _buildContactInfoCard(ExtendedData data, pw.Font font) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(20),
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Контактні дані',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.grey800,
            ),
          ),
          pw.SizedBox(height: 15),
          _buildInfoRow('Зареєстроване місце проживання', data.address, font),
          _buildInfoRow(
              'Адреса проживання',
              'Україна, Дніпропетровська обл., м.Дніпро, пров.Широкий, б. 15, кв.',
              font),
          pw.SizedBox(height: 10),
          _buildInfoRow('Телефон', data.phone, font),
          _buildInfoRow('Email', data.email, font),
          _buildInfoRow('Дата уточнення даних', '19.05.2024', font),
        ],
      ),
    );
  }

  static pw.Widget _buildInfoRow(String label, String value, pw.Font font) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 120,
            child: pw.Text(
              '$label:',
              style: pw.TextStyle(
                fontSize: 12,
                color: PdfColors.grey600,
                fontWeight: pw.FontWeight.normal,
                font: font,
              ),
            ),
          ),
          pw.Expanded(
            child: pw.Text(
              value,
              style: pw.TextStyle(
                fontSize: 12,
                color: PdfColors.grey800,
                fontWeight: pw.FontWeight.normal,
                font: font,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _getCurrentDateTime() {
    final now = DateTime.now();
    return '${now.day.toString().padLeft(2, '0')}.${now.month.toString().padLeft(2, '0')}.${now.year} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }
}
