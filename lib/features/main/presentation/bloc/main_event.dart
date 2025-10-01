import 'package:equatable/equatable.dart';

abstract class MainEvent extends Equatable {
  const MainEvent();

  @override
  List<Object?> get props => [];
}

class MainInitialized extends MainEvent {
  const MainInitialized();
}

class MainNavigationChanged extends MainEvent {
  final int index;

  const MainNavigationChanged(this.index);

  @override
  List<Object?> get props => [index];
}

class MainContainerToggled extends MainEvent {
  const MainContainerToggled();
}

class MainNotificationsChecked extends MainEvent {
  const MainNotificationsChecked();
}
