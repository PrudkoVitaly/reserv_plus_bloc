abstract class VacanciesRepository {
  /// Проверяет, нужно ли показывать онбординг
  Future<bool> shouldShowOnboarding();
  
  /// Устанавливает настройку "Больше не показывать"
  Future<void> setDontShowAgain(bool value);
}