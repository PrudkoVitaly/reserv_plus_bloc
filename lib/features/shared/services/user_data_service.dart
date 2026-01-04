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
  String get status => "Виключено з обліку";
  String get gender => "Чоловіча";
  String get taxId => "3209313875";
  String get placeOfBirth => "Україна, Дніпропетровська область, м Дніпро";
  String get address =>
      "Україна,\nДніпропетровська обл.,\nм.Дніпро,\nпров.Широкий, б. 15, кв.";
  String get phone => "380935306560";
  String get email => "eeemptyyy1991@gmail.com";
}
