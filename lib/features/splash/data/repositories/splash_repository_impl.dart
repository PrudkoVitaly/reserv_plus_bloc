import '../../domain/repositories/splash_repository.dart';

class SplashRepositoryImpl implements SplashRepository {
  @override
  Future<bool> shouldShowSplash() async {
    // Здесь может быть логика проверки:
    // - Первый запуск приложения
    // - Обновление приложения
    // - Проверка авторизации
    return true;
  }

  @override
  Future<Duration> getSplashDuration() async {
    // Здесь может быть логика получения времени:
    // - Из настроек приложения
    // - Из API
    // - По умолчанию 5 секунд
    return const Duration(seconds: 5);
  }
}
