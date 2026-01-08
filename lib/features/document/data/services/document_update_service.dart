import 'package:shared_preferences/shared_preferences.dart';

/// Сервис для отслеживания состояния анимации обновления документа
class DocumentUpdateService {
  static const String _updateStartTimeKey = 'document_update_start_time';
  static const int _updateAnimationDurationSeconds = 10;

  /// Сохраняет время начала обновления
  static Future<void> saveUpdateStartTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_updateStartTimeKey, DateTime.now().toIso8601String());
  }

  /// Проверяет, показывать ли жёлтую анимацию обновления
  static Future<bool> isUpdating() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTimestamp = prefs.getString(_updateStartTimeKey);

    if (savedTimestamp == null || savedTimestamp.isEmpty) {
      return false;
    }

    final updateStartTime = DateTime.parse(savedTimestamp);
    final now = DateTime.now();
    final difference = now.difference(updateStartTime);

    // Возвращаем true если прошло меньше 5 секунд
    return difference.inSeconds < _updateAnimationDurationSeconds;
  }

  /// Возвращает оставшееся время до окончания анимации в миллисекундах
  static Future<int> getRemainingTimeMs() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTimestamp = prefs.getString(_updateStartTimeKey);

    if (savedTimestamp == null || savedTimestamp.isEmpty) {
      return 0;
    }

    final updateStartTime = DateTime.parse(savedTimestamp);
    final now = DateTime.now();
    final elapsed = now.difference(updateStartTime).inMilliseconds;
    const totalDuration = _updateAnimationDurationSeconds * 1000;

    final remaining = totalDuration - elapsed;
    return remaining > 0 ? remaining : 0;
  }

  /// Очищает время обновления
  static Future<void> clearUpdateTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_updateStartTimeKey);
  }
}
