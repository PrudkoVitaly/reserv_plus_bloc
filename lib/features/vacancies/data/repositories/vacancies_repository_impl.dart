
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/repositories/vacancies_repository.dart';

class VacanciesRepositoryImpl implements VacanciesRepository {
  static const String _dontShowAgainKey = 'vacancies_dont_show_again';

  @override
  Future<bool> shouldShowOnboarding() async {
    // Всегда показываем онбординг при открытии приложения
    return true;
  }


  @override
  Future<void> toggleDontShowAgain() async {
    final prefs = await SharedPreferences.getInstance();
    final currentValue = prefs.getBool(_dontShowAgainKey) ?? false;
    await prefs.setBool(_dontShowAgainKey, !currentValue);
  }
}