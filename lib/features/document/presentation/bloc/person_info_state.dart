import 'package:equatable/equatable.dart';

abstract class PersonInfoState extends Equatable {
  const PersonInfoState();

  @override
  List<Object?> get props => [];
}

class PersonInfoInitial extends PersonInfoState {
  const PersonInfoInitial();
}

class PersonInfoLoading extends PersonInfoState {
  const PersonInfoLoading();
}

class PersonInfoLoaded extends PersonInfoState {
  final bool isModalVisible;

  const PersonInfoLoaded({this.isModalVisible = false});

  PersonInfoLoaded copyWith({bool? isModalVisible}) {
    return PersonInfoLoaded(
      isModalVisible: isModalVisible ?? this.isModalVisible,
    );
  }

  @override
  List<Object?> get props => [isModalVisible];
}

class PersonInfoError extends PersonInfoState {
  final String message;

  const PersonInfoError(this.message);

  @override
  List<Object?> get props => [message];
}
