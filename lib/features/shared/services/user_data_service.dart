class UserDataService {
  static final UserDataService _instance = UserDataService._internal();
  factory UserDataService() => _instance;
  UserDataService._internal();

  // Единые данные пользователя
  String get fullName => "Прудко Олександр Віталійович";
  String get firstName => "Олександр";
  String get lastName => "Прудко";
  String get patronymic => "Віталійович";
  String get birthDate => "13.07.1979";
  // String get fullName => "Марченко  Микола Володимирович";
  // String get firstName => "Микола";
  // String get lastName => "Марченко";
  // String get patronymic => "Володимирович";
  // String get birthDate => "03.05.1991";
  String get status => "Виключено з обліку";
  String get gender => "Чоловіча";
  String get taxId => "2904803892";
  String get placeOfBirth => "Україна, Дніпропетровська область, м Дніпро";
  String get address =>
      "Україна,\nДніпропетровська обл.,\nм.Дніпро,\n прос.Богдана Хмельницького, б.112, кв.51";
  String get phone => "380952308342";
  String get email => "PRUDKO.130779@gmail.com";
  String get registrationNumber => "150220221425429600027"; // Номер Оберіг

  // ВЛК данные
  String get vlkDate => "26.10.2024"; // Дата ВЛК
  // String get validityDate => "27.11.2025"; // Дійсний до - закомментировано, не понятно зачем нужно
  String get vlkProtocolNumber => "23/4567"; // Номер протоколу ВЛК
  String get vlkResolution =>
      "Непридатний до військової служби з виключенням з військового обліку"; // Постанова ВЛК

  // Військові дані
  String get vos => "999097"; // ВОС (військово-облікова спеціальність)
}
