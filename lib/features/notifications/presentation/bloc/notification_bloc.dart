import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reserv_plus/features/notifications/domain/repositories/notification_repository.dart';
import 'package:reserv_plus/features/notifications/presentation/bloc/notification_event.dart';
import 'package:reserv_plus/features/notifications/presentation/bloc/notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository _repository;

  NotificationBloc({required NotificationRepository repository})
      : _repository = repository,
        super(const NotificationInitial()) {
    // Регистрируем обработчики событий
    on<NotificationLoadAll>(_onLoadAll);
    on<NotificationAddRequestSent>(_onAddRequestSent);
    on<NotificationAddDataReceived>(_onAddDataReceived);
    on<NotificationMarkAsRead>(_onMarkAsRead);
  }

  // Обработчик события загрузки всех уведомлений
  Future<void> _onLoadAll(
    NotificationLoadAll event,
    Emitter<NotificationState> emit,
  ) async {
    emit(const NotificationLoading());

    try {
      final notifications = await _repository.getAllNotifications();
      emit(NotificationLoaded(notifications));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  /// Обработчик события добавления уведомления о запросе
  Future<void> _onAddRequestSent(
    NotificationAddRequestSent event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      // Добавляем новое уведомление в репозиторий
      await _repository.addNotification(event.notification);

      // Получаем обновленный список всех уведомлений
      final notifications = await _repository.getAllNotifications();
      emit(NotificationLoaded(notifications));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  // Обработчик события добавления уведомления о получении данных (с задержкой)
  Future<void> _onAddDataReceived(
    NotificationAddDataReceived event,
    Emitter<NotificationState> emit,
  ) async {
    // Ждем 5 секунд перед добавлением уведомления
    await Future.delayed(const Duration(seconds: 5));

    try {
      await _repository.addNotification(event.notification);
      final notifications = await _repository.getAllNotifications();
      emit(NotificationLoaded(notifications));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  // Обработчик события отметки уведомления как прочитанного
  Future<void> _onMarkAsRead(
    NotificationMarkAsRead event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      // Получаем все уведомления
      final notifications = await _repository.getAllNotifications();

      // Находим уведомление по id
      final notification = notifications.firstWhere(
        (n) => n.id == event.notificationId,
      );

      // Создаем обновленную версию с isRead = true
      final updatedNotification = notification.copyWith(isRead: true);

      // Обновляем в репозитории
      await _repository.updateNotification(updatedNotification);

      // Получаем обновленный список и эмитим новое состояние
      final updatedNotifications = await _repository.getAllNotifications();
      emit(NotificationLoaded(updatedNotifications));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }
}
