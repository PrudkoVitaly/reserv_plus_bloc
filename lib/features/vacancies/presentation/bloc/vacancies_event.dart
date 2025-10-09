import 'package:equatable/equatable.dart';

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