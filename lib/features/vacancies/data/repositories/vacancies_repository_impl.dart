import 'package:reserv_plus/features/vacancies/data/models/vacancy_data.dart';
import 'package:reserv_plus/features/vacancies/domain/entities/vacancy.dart';
import 'package:reserv_plus/features/vacancies/domain/entities/vacancy_category.dart';
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
  Future<void> setDontShowAgain(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_dontShowAgainKey, value);
  }

  // Методы для категорий вакансий
  @override
  Future<List<VacancyCategory>> getVacancyCategories() async {
    // Моковые данные для категорий
    // await Future.delayed(const Duration(seconds: 1)); // Убрал задержку

    return [
      const VacancyCategory(
        id: 'drones',
        name: 'Лінія дронів',
        description: 'Спеціалісти з дронів та БПЛА',
        iconPath: 'images/drone_icon.png',
      ),
      const VacancyCategory(
        id: 'for_you',
        name: 'Для вас',
        description: 'Персоналізовані рекомендації',
        iconPath: 'images/personal_icon.png',
      ),
      const VacancyCategory(
        id: 'all',
        name: 'Всі вакансії',
        description: 'Повний перелік доступних посад',
        iconPath: 'images/all_icon.png',
      ),
    ];
  }

  @override
  Future<void> selectCategory(VacancyCategory category) async {
    // Сохраняем выбранную категорию (пока в памяти)
    // В будущем можно сохранять в SharedPreferences
    // await Future.delayed(const Duration(milliseconds: 500)); // Убрал задержку
  }

  @override
  Future<VacancyCategory?> getSelectedCategory() async {
    // Получаем выбранную категорию
    await Future.delayed(const Duration(milliseconds: 100));
    return null; // Пока нет выбранной категории
  }

  @override
  Future<List<Vacancy>> getVacanciesForCategory(
      VacancyCategory category) async {
    await Future.delayed(const Duration(seconds: 1));

    // Моковые данные в зависимости от категории
    switch (category.id) {
      case 'drones':
        return _getDronesVacancies();
      case 'for_you':
        return _getPersonalVacancies();
      case 'all':
        return _getAllVacancies();
      default:
        return [];
    }
  }

  List<Vacancy> _getDronesVacancies() {
    return [
      Vacancy(
        id: 'drone_1',
        title: 'Оператор БПЛА',
        description: 'Управление безпілотними літальними апаратами',
        company: 'ЗСУ',
        location: 'Київ',
        salary: '25000-35000 грн',
        experience: '1-3 роки',
        requirements: ['Досвід роботи з дронами', 'Військова освіта'],
        benefits: ['Страхування', 'Відпустка'],
        categoryId: 'drones',
        createdAt: DateTime.now(),
        iconPath: 'images/drone_icon.png',
      ),
    ];
  }

  List<Vacancy> _getPersonalVacancies() {
    return [
      Vacancy(
        id: 'personal_1',
        title: 'Персоналізована вакансія',
        description: 'Рекомендована на основі вашого профілю',
        company: 'ЗСУ',
        location: 'Дніпро',
        salary: '30000-40000 грн',
        experience: '2-5 років',
        requirements: ['Відповідний досвід'],
        benefits: ['Повний соцпакет'],
        categoryId: 'for_you',
        createdAt: DateTime.now(),
        iconPath: 'images/drone_icon.png',
        ),
      Vacancy(
        id: 'personal_2',
        title: 'Персоналізована вакансія',
        description: 'Рекомендована на основі вашого профілю',
        company: 'ЗСУ',
        location: 'Дніпро',
        salary: '30000-40000 грн',
        experience: '2-5 років',
        requirements: ['Відповідний досвід'],
        benefits: ['Повний соцпакет'],
        categoryId: 'for_you',
        createdAt: DateTime.now(),
        iconPath: 'images/drone_icon.png',
      ),
    ];
  }

  List<Vacancy> _getAllVacancies() {
    return [
      // Объединяем все вакансии
      ..._getDronesVacancies(),
      ..._getPersonalVacancies(),
    ];
  }

  @override
  Future<List<Vacancy>> getAllVacancies() async {
    final allVacancies = VacancyData.getAllVacancies();

    return allVacancies.toList();
  }
}
