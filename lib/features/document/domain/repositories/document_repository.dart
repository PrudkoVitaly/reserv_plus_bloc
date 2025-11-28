import '../entities/document_data.dart';

abstract class DocumentRepository {
  /// Получает данные документа
  Future<DocumentData> getDocumentData();

  /// Обновляет данные документа
  Future<DocumentData> updateDocumentData();

  /// Скачивает PDF документа
  Future<String> downloadPdf();

  /// Исправляет данные онлайн
  Future<bool> correctDataOnline();

  /// Проверяет, можно ли обновить документ
  /// Возвращает true, если прошло 6 часов с последнего обновления
  Future<bool> canUpdateDocument();
}
