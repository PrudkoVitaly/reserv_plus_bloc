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
class NotificationAdd extends NotificationEvent {
  final NotificationEntity notification;

  const NotificationAdd(this.notification);

  @override
  List<Object?> get props => [notification];
}
