class UserDataService {
  static final UserDataService _instance = UserDataService._internal();
  factory UserDataService() => _instance;
  UserDataService._internal();

  // Единые данные пользователя
  String get fullName => "МАРЧЕНКО Микола Володимирович";
  String get firstName => "Микола";
  String get lastName => "МАРЧЕНКО";
  String get patronymic => "Володимирович";
  String get birthDate => "02.06.1991";
  String get status => "Не військовозобов'язаний";
  String get gender => "Чоловіча";
  String get taxId => "3209313875";
  String get placeOfBirth => "Україна, Дніпропетровська область, м Дніпро";
  String get address => "Україна,\nДніпропетровська обл.,\nм.Дніпро,\nпров.Широкий, б. 15, кв.";
  String get phone => "380935306560";
  String get email => "eeemptyyy1991@gmail.com";
}
