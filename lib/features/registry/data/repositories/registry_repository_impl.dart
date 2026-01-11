import '../../domain/entities/registry_data.dart';
import '../../domain/repositories/registry_repository.dart';

class RegistryRepositoryImpl implements RegistryRepository {
  @override
  Future<RegistryData> getRegistryData() async {
    // Имитация задержки загрузки данных из реестра
    await Future.delayed(const Duration(milliseconds: 200));

    // В реальном приложении здесь будет API запрос к реестру Оберіг
    return const RegistryData(
      fullName: "Іван Іванович Іванов",
      status: "На обліку",
      registrationNumber: "1234567890",
      birthDate: "01.01.1990",
      address: "м. Київ, вул. Хрещатик, 1",
      hasNotifications: true,
    );
  }

  @override
  Future<bool> isDataLoaded() async {
    // В реальном приложении здесь будет проверка кеша или локальной БД
    return false;
  }

  @override
  Future<Duration> getLoadingDuration() async {
    // В реальном приложении время может зависеть от размера данных
    return const Duration(seconds: 5);
  }
}
