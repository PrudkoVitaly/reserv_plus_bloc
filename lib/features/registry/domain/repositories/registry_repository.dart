import '../entities/registry_data.dart';

abstract class RegistryRepository {
  /// Получает данные из реестра
  Future<RegistryData> getRegistryData();

  /// Проверяет статус загрузки
  Future<bool> isDataLoaded();

  /// Получает время загрузки
  Future<Duration> getLoadingDuration();
}
