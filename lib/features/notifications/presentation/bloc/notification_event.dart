import 'package:equatable/equatable.dart';
import 'package:reserv_plus/features/notifications/domain/entities/notification.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

// Событие для загрузки всех уведомлений
class NotificationLoadAll extends NotificationEvent {
  const NotificationLoadAll();
}

// Событие для добавления нового уведомления
class NotificationAddRequestSent extends NotificationEvent {
  final NotificationEntity notification;

  const NotificationAddRequestSent(this.notification);

  @override
  List<Object?> get props => [notification];
}

// Событие для добавления нового уведомления о получении данных из реестра
class NotificationAddDataReceived extends NotificationEvent {
  final NotificationEntity notification;
  const NotificationAddDataReceived(this.notification);
  @override
  List<Object?> get props => [notification];
}

// Событие для отметки уведомления как прочитанного
class NotificationMarkAsRead extends NotificationEvent {
  final String notificationId;

  const NotificationMarkAsRead(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}
