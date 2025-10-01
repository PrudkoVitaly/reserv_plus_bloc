abstract class LoadingRepository {
  /// Выполняет загрузку данных
  Future<void> performLoading();

  /// Получает время загрузки
  Future<Duration> getLoadingDuration();

  /// Проверяет, нужно ли показывать загрузку
  Future<bool> shouldShowLoading();
}
