import 'package:shared_preferences/shared_preferences.dart';

/// Сервис для отслеживания времени последнего запроса на исправление данных
/// Блокирует повторную отправку на 1 час после предыдущего запроса
class FixDataRequestService {
  static const String _lastRequestTimeKey = 'fix_data_last_request_time';
  static const Duration _cooldownDuration = Duration(hours: 1);

  /// Проверяет, можно ли отправить новый запрос
  /// Возвращает true если прошёл час с последнего запроса или запросов не было
  static Future<bool> canSubmitRequest() async {
    final prefs = await SharedPreferences.getInstance();
    final lastRequestTime = prefs.getInt(_lastRequestTimeKey);

    if (lastRequestTime == null) {
      return true; // Запросов ещё не было
    }

    final lastRequest = DateTime.fromMillisecondsSinceEpoch(lastRequestTime);
    final now = DateTime.now();
    final difference = now.difference(lastRequest);

    return difference >= _cooldownDuration;
  }

  /// Сохраняет время текущего запроса
  static Future<void> saveRequestTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastRequestTimeKey, DateTime.now().millisecondsSinceEpoch);
  }

  /// Возвращает оставшееся время до возможности нового запроса
  /// Возвращает null если можно отправить запрос сейчас
  static Future<Duration?> getRemainingCooldown() async {
    final prefs = await SharedPreferences.getInstance();
    final lastRequestTime = prefs.getInt(_lastRequestTimeKey);

    if (lastRequestTime == null) {
      return null;
    }

    final lastRequest = DateTime.fromMillisecondsSinceEpoch(lastRequestTime);
    final now = DateTime.now();
    final difference = now.difference(lastRequest);

    if (difference >= _cooldownDuration) {
      return null;
    }

    return _cooldownDuration - difference;
  }

  /// Сбрасывает время последнего запроса (для тестирования)
  static Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_lastRequestTimeKey);
  }
}
