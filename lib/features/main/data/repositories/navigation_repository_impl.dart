import '../../domain/entities/navigation_state.dart';
import '../../domain/repositories/navigation_repository.dart';
import 'package:reserv_plus/features/notifications/domain/repositories/notification_repository.dart';

class NavigationRepositoryImpl implements NavigationRepository {
  final NotificationRepository _notificationRepository;
  NavigationState _currentState = const NavigationState();

  NavigationRepositoryImpl(
      {required NotificationRepository notificationRepository})
      : _notificationRepository = notificationRepository;

  @override
  Future<NavigationState> getNavigationState() async {
    // В реальном приложении здесь будет загрузка из SharedPreferences или локальной БД
    return _currentState;
  }

  @override
  Future<void> saveNavigationState(NavigationState state) async {
    // В реальном приложении здесь будет сохранение в SharedPreferences или локальную БД
    _currentState = state;
  }

  @override
  Future<bool> hasNotifications() async {
    try {
      // Получаем все уведомления
      final notifications = await _notificationRepository.getAllNotifications();
      // Проверяем есть ли хотя бы одно непрочитанное уведомление
      return notifications.any((notification) => !notification.isRead);
    } catch (e) {
      // В случае ошибки возвращаем false
      return false;
    }
  }
}
