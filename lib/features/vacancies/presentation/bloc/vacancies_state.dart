import 'package:equatable/equatable.dart';

abstract class VacanciesState extends Equatable{
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