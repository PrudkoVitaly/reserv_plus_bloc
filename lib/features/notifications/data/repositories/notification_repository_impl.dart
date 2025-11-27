import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:reserv_plus/features/notifications/domain/entities/notification.dart';
import 'package:reserv_plus/features/notifications/domain/repositories/notification_repository.dart';
// import 'package:reserv_plus/features/notifications/data/notification_data.dart'; // Закомментировано для тестирования

class NotificationRepositoryImpl implements NotificationRepository {
  static const String _notificationsKey = 'notifications_list';

  // Загружаем уведомления из SharedPreferences или используем начальные
  Future<List<NotificationEntity>> _loadNotifications() async {
    final prefs = await SharedPreferences.getInstance();

    // ВРЕМЕННО: Очищаем данные для тестирования (удалить после теста!)
    // await prefs.remove(_notificationsKey);

    final notificationsJson = prefs.getString(_notificationsKey);

    if (notificationsJson != null && notificationsJson.isNotEmpty) {
      try {
        final List<dynamic> decoded = jsonDecode(notificationsJson);
        return decoded
            .map((json) => _fromJson(json as Map<String, dynamic>))
            .toList();
      } catch (e) {
        // Если ошибка при десериализации, используем начальные данные
        // return NotificationData.getInitialNotifications();
        return []; // Возвращаем пустой список для тестирования
      }
    } else {
      // Первый запуск - используем начальные данные и сохраняем их
      // final initialNotifications = NotificationData.getInitialNotifications();
      // await _saveNotifications(initialNotifications);
      // return initialNotifications;
      return []; // Возвращаем пустой список для тестирования
    }
  }

  // Сохраняем уведомления в SharedPreferences
  Future<void> _saveNotifications(
      List<NotificationEntity> notifications) async {
    final prefs = await SharedPreferences.getInstance();
    final notificationsJson = jsonEncode(
      notifications.map((n) => _toJson(n)).toList(),
    );
    await prefs.setString(_notificationsKey, notificationsJson);
  }

  // Преобразуем NotificationEntity в Map для JSON
  Map<String, dynamic> _toJson(NotificationEntity notification) {
    return {
      'id': notification.id,
      'title': notification.title,
      'subtitle': notification.subtitle,
      'timestamp': notification.timestamp.toIso8601String(),
      'isRead': notification.isRead,
    };
  }

  // Преобразуем Map из JSON в NotificationEntity
  NotificationEntity _fromJson(Map<String, dynamic> json) {
    return NotificationEntity(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isRead: json['isRead'] as bool? ?? false,
    );
  }

  @override
  Future<List<NotificationEntity>> getAllNotifications() async {
    final notifications = await _loadNotifications();
    // Возвращаем список, отсортированный по дате (новые первыми)
    final sorted = List<NotificationEntity>.from(notifications);
    sorted.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return sorted;
  }

  @override
  Future<NotificationEntity> addNotification(
      NotificationEntity notification) async {
    final notifications = await _loadNotifications();
    // Добавляем новое уведомление в начало списка
    notifications.insert(0, notification);
    // Сохраняем обновленный список
    await _saveNotifications(notifications);
    return notification;
  }

  @override
  Future<NotificationEntity> updateNotification(
      NotificationEntity notification) async {
    final notifications = await _loadNotifications();

    // Находим индекс уведомления по id
    final index = notifications.indexWhere((n) => n.id == notification.id);
    if (index != -1) {
      notifications[index] = notification;
      await _saveNotifications(notifications);
    }
    return notification;
  }
}
