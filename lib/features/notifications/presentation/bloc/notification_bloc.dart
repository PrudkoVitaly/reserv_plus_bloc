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
    on<NotificationAdd>(_onAdd);
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

  // Обработчик события добавления уведомления
  Future<void> _onAdd(
    NotificationAdd event,
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
}
