import '../../domain/entities/person_info.dart';
import '../../domain/repositories/person_info_repository.dart';
import 'package:reserv_plus/features/shared/services/user_data_service.dart';

class PersonInfoRepositoryImpl implements PersonInfoRepository {
  String _formatLastUpdated(DateTime dateTime) {
    final time =
        "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
    final date =
        "${dateTime.day.toString().padLeft(2, '0')}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.year}";
    return "Документ оновлено о $time | $date";
  }

  String _formatPhone(String phone) {
    // Форматируем номер телефона в формат +380 95 361 4443
    if (phone.length >= 12) {
      return '+${phone.substring(0, 3)} ${phone.substring(3, 5)} ${phone.substring(5, 8)} ${phone.substring(8, 12)}';
    }
    return phone;
  }

  @override
  Future<PersonInfo> getPersonInfo() async {
    // Здесь будет реальная логика получения данных
    // Пока возвращаем моковые данные из вашего кода
    await Future.delayed(const Duration(seconds: 1)); // Имитация загрузки

    final now = DateTime.now();
    final formattedTime = _formatLastUpdated(now);
    final userData = UserDataService();

    return PersonInfo(
      fullName: userData.fullName,
      status: userData.status,
      birthDate: userData.birthDate,
      rnokpp: userData.taxId,
      exclusionReason: "непридатні",
      vlcDecision: "Непридатний\nз\nвиключенням\nз військового\nобліку",
      vlcDate: "27.11.2025",
      tckName:
          "Амур-Нижньодніпровський районий територіальний центр\nкомплектування та соціальної підтримки",
      rank: "Солдат",
      vos: "903467",
      category: "Не військовообов'язковий",
      position: "Діловодства, Діловод",
      registrationNumber: "218746994405878364744",
      phone: _formatPhone(userData.phone),
      email: userData.email,
      address: userData.address,
      dataUpdateDate: "06.11.2024",
      lastUpdateDate: "06.11.2024",
      lastUpdated: now,
      formattedLastUpdated: formattedTime,
    );
  }
}
