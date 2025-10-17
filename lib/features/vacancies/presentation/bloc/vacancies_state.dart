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

  const VacanciesCategoriesLoaded({
    required this.categories,
    this.selectedCategory,
    this.isHighlighted = false,
  });

  VacanciesCategoriesLoaded copyWith({
    List<VacancyCategory>? categories,
    VacancyCategory? selectedCategory,
    bool? isHighlighted,
  }) {
    return VacanciesCategoriesLoaded(
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      isHighlighted: isHighlighted ?? this.isHighlighted,
    );
  }

  @override
  List<Object?> get props => [categories, selectedCategory, isHighlighted];
}

class VacanciesVacanciesLoaded extends VacanciesState {
  final VacancyCategory selectedCategory;
  final List<Vacancy> vacancies;

  const VacanciesVacanciesLoaded({
    required this.selectedCategory,
    required this.vacancies,
  });

  @override
  List<Object?> get props => [selectedCategory, vacancies];
}
