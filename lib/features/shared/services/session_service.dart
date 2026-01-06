import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

class SessionService {
  static const String _firstLaunchKey = 'session_first_launch_time';
  static const String _lastActivityKey = 'session_last_activity_time';

  /// Получить дату первого запуска (подключения)
  /// Возвращает дату на 6 месяцев раньше для реалистичности
  static Future<DateTime> getFirstLaunchDate() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt(_firstLaunchKey);

    if (timestamp == null) {
      // Первый запуск - сохраняем дату на 6 месяцев раньше
      final now = DateTime.now();
      final sixMonthsAgo = DateTime(now.year, now.month - 6, now.day, now.hour, now.minute);
      await prefs.setInt(_firstLaunchKey, sixMonthsAgo.millisecondsSinceEpoch);
      return sixMonthsAgo;
    }

    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  /// Обновить время последней активности
  static Future<void> updateLastActivity() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastActivityKey, DateTime.now().millisecondsSinceEpoch);
  }

  /// Получить время последней активности
  static Future<DateTime> getLastActivity() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt(_lastActivityKey);

    if (timestamp == null) {
      return DateTime.now();
    }

    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  /// Получить название устройства с версией ОС
  static Future<String> getDeviceName() async {
    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return 'Android ${androidInfo.version.release}';
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return 'iOS ${iosInfo.systemVersion}';
    }

    return 'Unknown Device';
  }

  /// Форматировать дату для отображения
  static String formatConnectionDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '$day.$month.$year, $hour:$minute';
  }

  /// Форматировать последнюю активность
  static String formatLastActivity(DateTime lastActivity) {
    final now = DateTime.now();
    final hour = lastActivity.hour.toString().padLeft(2, '0');
    final minute = lastActivity.minute.toString().padLeft(2, '0');

    // Проверяем, была ли активность сегодня
    if (lastActivity.year == now.year &&
        lastActivity.month == now.month &&
        lastActivity.day == now.day) {
      return 'сьогодні, $hour:$minute';
    }

    // Проверяем, была ли активность вчера
    final yesterday = now.subtract(const Duration(days: 1));
    if (lastActivity.year == yesterday.year &&
        lastActivity.month == yesterday.month &&
        lastActivity.day == yesterday.day) {
      return 'вчора, $hour:$minute';
    }

    // Иначе показываем полную дату
    final day = lastActivity.day.toString().padLeft(2, '0');
    final month = lastActivity.month.toString().padLeft(2, '0');
    return '$day.$month.${lastActivity.year}, $hour:$minute';
  }
}
