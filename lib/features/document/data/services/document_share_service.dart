import 'package:share_plus/share_plus.dart';

/// Сервис для работы с системным Share Sheet
class DocumentShareService {
  /// Поделиться текстом через системный Share Sheet
  static Future<void> shareText({
    required String text,
    String? subject,
  }) async {
    try {
      await Share.share(
        text,
        subject: subject,
      );
    } catch (e) {
      throw Exception('Ошибка при попытке поделиться: $e');
    }
  }

  /// Поделиться файлом через системный Share Sheet
  static Future<void> shareFile({
    required String filePath,
    String? text,
    String? subject,
  }) async {
    try {
      await Share.shareXFiles(
        [XFile(filePath)],
        text: text,
        subject: subject,
      );
    } catch (e) {
      throw Exception('Ошибка при попытке поделиться файлом: $e');
    }
  }

  /// Поделиться данными документа как текстом
  static Future<void> shareDocumentData({
    required String fullName,
    required String birthDate,
    required String status,
    required String validityDate,
    required String lastUpdated,
  }) async {
    final documentText = '''
📋 Військово-обліковий документ

👤 ПІБ: $fullName
📅 Дата народження: $birthDate
📊 Статус: $status
✅ Дійсний до: $validityDate
🕒 Останнє оновлення: $lastUpdated

Документ згенеровано додатком Резерв+
''';

    await shareText(
      text: documentText,
      subject: 'Військово-обліковий документ',
    );
  }
}
