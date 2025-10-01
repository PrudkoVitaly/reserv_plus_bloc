import 'package:equatable/equatable.dart';

abstract class PersonInfoEvent extends Equatable {
  const PersonInfoEvent();

  @override
  List<Object?> get props => [];
}

class PersonInfoLoadData extends PersonInfoEvent {
  const PersonInfoLoadData();
}

class PersonInfoShowModal extends PersonInfoEvent {
  const PersonInfoShowModal();
}

class PersonInfoHideModal extends PersonInfoEvent {
  const PersonInfoHideModal();
}
