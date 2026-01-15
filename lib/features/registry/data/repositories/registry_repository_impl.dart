import 'package:reserv_plus/features/shared/services/user_data_service.dart';

import '../../domain/entities/registry_data.dart';
import '../../domain/repositories/registry_repository.dart';

class RegistryRepositoryImpl implements RegistryRepository {
  @override
  Future<RegistryData> getRegistryData() async {
    // Имитация задержки загрузки данных из реестра
    await Future.delayed(const Duration(milliseconds: 200));

    final userData = UserDataService();

    // В реальном приложении здесь будет API запрос к реестру Оберіг
    return RegistryData(
      fullName: userData.fullName,
      status: userData.status,
      registrationNumber: userData.registrationNumber,
      birthDate: userData.birthDate,
      address: userData.address,
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
