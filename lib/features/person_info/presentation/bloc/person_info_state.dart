import '../../domain/entities/person_info.dart';

abstract class PersonInfoState {}

class PersonInfoLoading extends PersonInfoState {}

class PersonInfoLoaded extends PersonInfoState {
  final PersonInfo personInfo;

  PersonInfoLoaded(this.personInfo);
}

class PersonInfoError extends PersonInfoState {
  final String message;

  PersonInfoError(this.message);
}
