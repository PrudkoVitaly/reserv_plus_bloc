abstract class VacanciesRepository {
  /// Проверяет, нужно ли показывать онбординг
  Future<bool> shouldShowOnboarding();
  
  /// Переключает настройку "Больше не показывать"
  Future<void> toggleDontShowAgain();
}