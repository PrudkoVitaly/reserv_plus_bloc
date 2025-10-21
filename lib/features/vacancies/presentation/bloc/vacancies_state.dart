import 'package:equatable/equatable.dart';
import 'package:reserv_plus/features/vacancies/domain/entities/vacancy.dart';
import 'package:reserv_plus/features/vacancies/domain/entities/vacancy_category.dart';

abstract class VacanciesState extends Equatable {
  const VacanciesState();

  @override
  List<Object?> get props => [];
}

class VacanciesInitial extends VacanciesState {
  const VacanciesInitial();
}

class VacanciesLoading extends VacanciesState {
  const VacanciesLoading();
}

class VacanciesLoaded extends VacanciesState {
  final bool showOnboarding;

  const VacanciesLoaded({
    this.showOnboarding = true,
  });

  VacanciesLoaded copyWith({
    bool? showOnboarding,
  }) {
    return VacanciesLoaded(
      showOnboarding: showOnboarding ?? this.showOnboarding,
    );
  }

  @override
  List<Object?> get props => [showOnboarding];
}

class VacanciesError extends VacanciesState {
  final String message;

  const VacanciesError(this.message);

  @override
  List<Object?> get props => [message];
}

// СОСТОЯНИЯ для категорий
class VacanciesCategoriesLoading extends VacanciesState {
  const VacanciesCategoriesLoading();
}

class VacanciesCategoriesLoaded extends VacanciesState {
  final List<VacancyCategory> categories;
  final VacancyCategory? selectedCategory;
  final bool isHighlighted;
  final List<Vacancy>? loadedVacancies;

  const VacanciesCategoriesLoaded({
    required this.categories,
    this.selectedCategory,
    this.isHighlighted = false,
    this.loadedVacancies,
  });

  VacanciesCategoriesLoaded copyWith({
    List<VacancyCategory>? categories,
    VacancyCategory? selectedCategory,
    bool? isHighlighted,
    List<Vacancy>? loadedVacancies,
  }) {
    return VacanciesCategoriesLoaded(
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      isHighlighted: isHighlighted ?? this.isHighlighted,
      loadedVacancies: loadedVacancies ?? this.loadedVacancies,
    );
  }

  @override
  List<Object?> get props =>
      [categories, selectedCategory, isHighlighted, loadedVacancies];
}
