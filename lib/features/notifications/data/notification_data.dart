import 'package:reserv_plus/features/notifications/domain/entities/notification.dart';

class NotificationData {
  static List<NotificationEntity> getInitialNotifications() {
    return [
      NotificationEntity(
        id: '1',
        title: 'Дані з реєстру Оберіг отримано',
        subtitle: 'Військово-обліковий документ вже доступний',
        timestamp: DateTime(2025, 10, 16, 22, 42),
      ),
      NotificationEntity(
        id: '2',
        title: 'Запит на інформацію з реєстру відправлено',
        subtitle: 'Очікуйте сповіщення про результат обробки запиту',
        timestamp: DateTime(2025, 10, 16, 22, 41),
      ),
      NotificationEntity(
        id: '1',
        title: 'Дані з реєстру Оберіг отримано',
        subtitle: 'Військово-обліковий документ вже доступний',
        timestamp: DateTime(2025, 10, 16, 22, 42),
      ),
      NotificationEntity(
        id: '1',
        title: 'Дані з реєстру Оберіг отримано',
        subtitle: 'Військово-обліковий документ вже доступний',
        timestamp: DateTime(2025, 10, 16, 22, 42),
      ),
      NotificationEntity(
        id: '1',
        title: 'Дані з реєстру Оберіг отримано',
        subtitle: 'Військово-обліковий документ вже доступний',
        timestamp: DateTime(2025, 10, 16, 22, 42),
      ),
      NotificationEntity(
        id: '1',
        title: 'Дані з реєстру Оберіг отримано',
        subtitle: 'Військово-обліковий документ вже доступний',
        timestamp: DateTime(2025, 10, 16, 22, 42),
      ),
      // ... остальные уведомления
    ];
  }
}
