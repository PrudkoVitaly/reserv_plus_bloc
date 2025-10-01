import '../entities/navigation_state.dart';

abstract class NavigationRepository {
  /// Получает текущее состояние навигации
  Future<NavigationState> getNavigationState();

  /// Сохраняет состояние навигации
  Future<void> saveNavigationState(NavigationState state);

  /// Проверяет наличие уведомлений
  Future<bool> hasNotifications();
}
