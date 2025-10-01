import '../../domain/repositories/loading_repository.dart';

class LoadingRepositoryImpl implements LoadingRepository {
  @override
  Future<void> performLoading() async {
    // Имитация загрузки данных
    await Future.delayed(const Duration(seconds: 3));
  }

  @override
  Future<Duration> getLoadingDuration() async {
    // В реальном приложении время может зависеть от размера данных
    return const Duration(seconds: 3);
  }

  @override
  Future<bool> shouldShowLoading() async {
    // В реальном приложении здесь может быть проверка кеша или состояния
    return true;
  }
}
