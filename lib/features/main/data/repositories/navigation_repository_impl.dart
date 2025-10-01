import '../../domain/entities/navigation_state.dart';
import '../../domain/repositories/navigation_repository.dart';

class NavigationRepositoryImpl implements NavigationRepository {
  NavigationState _currentState = const NavigationState();

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
    // В реальном приложении здесь будет проверка уведомлений
    return true; // Всегда есть уведомления для демонстрации
  }
}
