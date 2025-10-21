import 'package:reserv_plus/features/vacancies/domain/entities/vacancy.dart';
import 'package:reserv_plus/features/vacancies/domain/entities/vacancy_category.dart';

abstract class VacanciesRepository {
  // Проверяет, нужно ли показывать онбординг
  Future<bool> shouldShowOnboarding();

  // Устанавливает настройку "Больше не показывать"
  Future<void> setDontShowAgain(bool value);

  // Методы для категорий вакансий
  Future<List<VacancyCategory>> getVacancyCategories();
  Future<void> selectCategory(VacancyCategory category);
  Future<VacancyCategory?> getSelectedCategory();
  Future<List<Vacancy>> getVacanciesForCategory(VacancyCategory category);

  // Методы для всех вакансий
  Future<List<Vacancy>> getAllVacancies();
}
