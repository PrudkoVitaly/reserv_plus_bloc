import 'package:equatable/equatable.dart';
import 'package:reserv_plus/features/vacancies/domain/entities/vacancy_category.dart';

abstract class VacanciesEvent extends Equatable {
  const VacanciesEvent();

  @override
  List<Object?> get props => [];
}

class VacanciesInitialized extends VacanciesEvent {
  const VacanciesInitialized();
}

class VacanciesStartPressed extends VacanciesEvent {
  const VacanciesStartPressed();
}

class VacanciesSetDontShowAgain extends VacanciesEvent {
  final bool value;
  const VacanciesSetDontShowAgain(this.value);

  @override
  List<Object?> get props => [value];
}

class VacanciesPageOpened extends VacanciesEvent {
  const VacanciesPageOpened();
}

// EVENTS для категорий
class VacanciesLoadCategories extends VacanciesEvent {
  const VacanciesLoadCategories();
}

class VacanciesSelectCategory extends VacanciesEvent {
  final VacancyCategory category;
  const VacanciesSelectCategory(this.category);

  @override
  List<Object?> get props => [category];
}
