import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/document_data.dart';
import '../../domain/repositories/document_repository.dart';
import 'package:reserv_plus/features/shared/services/user_data_service.dart';

class DocumentRepositoryImpl implements DocumentRepository {
  static const String _lastUpdatedKey = 'last_updated_timestamp';

  String _formatLastUpdated(DateTime dateTime) {
    final time =
        "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
    final date =
        "${dateTime.day.toString().padLeft(2, '0')}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.year}";
    return "Документ оновлено о $time | $date";
  }

  @override
  Future<DocumentData> getDocumentData() async {
    // Загружаем сохраненное время последнего обновления
    final prefs = await SharedPreferences.getInstance();
    final savedTimestamp = prefs.getString(_lastUpdatedKey);

    // Если есть сохраненная дата, используем её, иначе текущую
    final DateTime lastUpdated;
    if (savedTimestamp != null && savedTimestamp.isNotEmpty) {
      lastUpdated = DateTime.parse(savedTimestamp);
    } else {
      // Первый запуск - используем текущее время и сохраняем его
      lastUpdated = DateTime.now();
      await prefs.setString(_lastUpdatedKey, lastUpdated.toIso8601String());
    }

    final userData = UserDataService();

    return DocumentData(
      fullName: userData.fullName,
      firstName: userData.firstName,
      lastName: userData.lastName,
      patronymic: userData.patronymic,
      birthDate: userData.birthDate,
      status: userData.status,
      validityDate: "", // Не используется для "Виключено з обліку"
      qrCode: "images/qr_code.png",
      lastUpdated: lastUpdated,
      formattedLastUpdated: _formatLastUpdated(lastUpdated),
      isDataUpToDate: true,
    );
  }

  @override
  Future<DocumentData> updateDocumentData() async {
    // Имитация обновления данных
    await Future.delayed(const Duration(seconds: 2));

    final now = DateTime.now();

    // Сохраняем новое время обновления
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastUpdatedKey, now.toIso8601String());

    final userData = UserDataService();

    return DocumentData(
      fullName: userData.fullName,
      firstName: userData.firstName,
      lastName: userData.lastName,
      patronymic: userData.patronymic,
      birthDate: userData.birthDate,
      status: userData.status,
      validityDate: "", // Не используется для "Виключено з обліку"
      qrCode: "images/qr_code.png",
      lastUpdated: now,
      formattedLastUpdated: _formatLastUpdated(now),
      isDataUpToDate: true,
    );
  }

  @override
  Future<String> downloadPdf() async {
    // Имитация скачивания PDF
    await Future.delayed(const Duration(seconds: 1));
    return "document.pdf";
  }

  @override
  Future<bool> correctDataOnline() async {
    // Имитация исправления данных
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  @override
  Future<bool> canUpdateDocument() async {
    // Получаем сохраненное время последнего обновления
    final prefs = await SharedPreferences.getInstance();
    final savedTimestamp = prefs.getString(_lastUpdatedKey);

    // Если нет сохраненного времени - это первое обновление, разрешаем
    if (savedTimestamp == null || savedTimestamp.isEmpty) {
      return true;
    }

    // Парсим сохраненное время
    final lastUpdated = DateTime.parse(savedTimestamp);
    final now = DateTime.now();

    // Вычисляем разницу во времени
    final difference = now.difference(lastUpdated);

    // TODO: Вернуть 6 часов после тестирования
    // Проверяем, прошло ли 5 секунд (для тестирования)
    // Возвращаем true, если прошло >= 5 секунд
    return difference.inSeconds >= 5;
  }
}
