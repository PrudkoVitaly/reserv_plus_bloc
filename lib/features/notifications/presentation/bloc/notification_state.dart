import 'package:equatable/equatable.dart';
import 'package:reserv_plus/features/notifications/domain/entities/notification.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

// Начальное состояние
class NotificationInitial extends NotificationState {
  const NotificationInitial();
}

// Состояние загрузки
class NotificationLoading extends NotificationState {
  const NotificationLoading();
}

// Состояние успешной загрузки с данными
class NotificationLoaded extends NotificationState {
  final List<NotificationEntity> notifications;

  const NotificationLoaded(this.notifications);

  @override
  List<Object?> get props => [notifications];
}

// Состояние ошибки
class NotificationError extends NotificationState {
  final String message;

  const NotificationError(this.message);

  @override
  List<Object?> get props => [message];
}
