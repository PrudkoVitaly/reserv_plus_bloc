abstract class SplashRepository {
  /// Проверяет, нужно ли показывать splash экран
  Future<bool> shouldShowSplash();

  /// Получает время загрузки splash экрана
  Future<Duration> getSplashDuration();
}
