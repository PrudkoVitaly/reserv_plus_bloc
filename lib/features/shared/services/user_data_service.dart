class UserDataService {
  static final UserDataService _instance = UserDataService._internal();
  factory UserDataService() => _instance;
  UserDataService._internal();

  // Единые данные пользователя
  String get fullName => "ПРУДКО Валентин Віталійович";
  String get firstName => "Валентин";
  String get lastName => "ПРУДКО";
  String get patronymic => "Віталійович";
  String get birthDate => "13.11.1987";
  String get status => "Не військовозобов'язаний";
  String get gender => "Чоловіча";
  String get taxId => "3209313875";
  String get placeOfBirth => "Україна, Дніпропетровська область, м Дніпро";
  String get address => "Дніпропетровська область, м Дніпро, Широкий, б. 15";
  String get phone => "380953614443";
  String get email => "PRUDKOVITALIK@GMAIL.COM";
}
