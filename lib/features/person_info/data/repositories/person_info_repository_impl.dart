import '../../domain/entities/person_info.dart';
import '../../domain/repositories/person_info_repository.dart';

class PersonInfoRepositoryImpl implements PersonInfoRepository {
  String _formatLastUpdated(DateTime dateTime) {
    final time =
        "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
    final date =
        "${dateTime.day.toString().padLeft(2, '0')}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.year}";
    return "Документ оновлено о $time | $date";
  }

  @override
  Future<PersonInfo> getPersonInfo() async {
    // Здесь будет реальная логика получения данных
    // Пока возвращаем моковые данные из вашего кода
    await Future.delayed(const Duration(seconds: 1)); // Имитация загрузки

    final now = DateTime.now();
    final formattedTime = _formatLastUpdated(now);

    return PersonInfo(
      fullName: "ПРУДКО Валентин Віталійович",
      status: "Виключено",
      birthDate: "13.11.1987",
      rnokpp: "3287857408",
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
      phone: "+38 095 928 7058",
      email: "PRUDKOVALENTIN@gmail.com",
      address:
          "Україна, Дніпропетровська обл.,\nм.Дніпро, пров. Пушкінська, б.10, кв.2",
      dataUpdateDate: "06.11.2024",
      lastUpdateDate: "06.11.2024",
      lastUpdated: now,
      formattedLastUpdated: formattedTime,
    );
  }
}
