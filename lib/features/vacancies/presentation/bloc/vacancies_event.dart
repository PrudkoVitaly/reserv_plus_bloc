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

class VacanciesDontShowAgainToggled extends VacanciesEvent {
  const VacanciesDontShowAgainToggled();
}

class VacanciesPageOpened extends VacanciesEvent {
  const VacanciesPageOpened();
}