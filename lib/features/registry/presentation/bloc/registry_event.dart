import 'package:equatable/equatable.dart';

abstract class RegistryEvent extends Equatable {
  const RegistryEvent();

  @override
  List<Object?> get props => [];
}

class RegistryLoadData extends RegistryEvent {
  const RegistryLoadData();
}

class RegistryNavigationChanged extends RegistryEvent {
  final int index;

  const RegistryNavigationChanged(this.index);

  @override
  List<Object?> get props => [index];
}

class RegistryRetry extends RegistryEvent {
  const RegistryRetry();
}
