import 'package:reserv_plus/features/notifications/domain/entities/notification.dart';
import 'package:reserv_plus/features/notifications/domain/repositories/notification_repository.dart';
import 'package:reserv_plus/features/notifications/data/notification_data.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  // Статический список - общий для всех экземпляров репозитория
  static List<NotificationEntity> _notifications =
      NotificationData.getInitialNotifications();

  @override
  Future<List<NotificationEntity>> getAllNotifications() async {
    // Возвращаем список, отсортированный по дате (новые первыми)
    final sorted = List<NotificationEntity>.from(_notifications);
    sorted.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return sorted;
  }

  @override
  Future<NotificationEntity> addNotification(
      NotificationEntity notification) async {
    // Добавляем новое уведомление в начало списка
    _notifications.insert(0, notification);
    return notification;
  }
}
