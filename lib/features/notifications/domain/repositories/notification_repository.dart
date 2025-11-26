import 'package:reserv_plus/features/notifications/domain/entities/notification.dart';

/// Интерфейс репозитория для работы с уведомлениями
/// Определяет контракт для получения и управления уведомлениями
abstract class NotificationRepository {
  /// Получает все уведомления
  /// Возвращает список всех уведомлений, отсортированных по дате (новые первыми)
  Future<List<NotificationEntity>> getAllNotifications();

  /// Добавляет новое уведомление
  /// [notification] - уведомление для добавления
  /// Возвращает добавленное уведомление
  Future<NotificationEntity> addNotification(NotificationEntity notification);
}
