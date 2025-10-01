import 'package:equatable/equatable.dart';
import '../../domain/entities/registry_data.dart';

abstract class RegistryState extends Equatable {
  const RegistryState();

  @override
  List<Object?> get props => [];
}

class RegistryInitial extends RegistryState {
  const RegistryInitial();
}

class RegistryLoading extends RegistryState {
  final int currentTabIndex;

  const RegistryLoading({this.currentTabIndex = 0});

  @override
  List<Object?> get props => [currentTabIndex];
}

class RegistrySuccess extends RegistryState {
  final RegistryData data;
  final int currentTabIndex;

  const RegistrySuccess({
    required this.data,
    this.currentTabIndex = 0,
  });

  @override
  List<Object?> get props => [data, currentTabIndex];
}

class RegistryError extends RegistryState {
  final String message;
  final int currentTabIndex;

  const RegistryError({
    required this.message,
    this.currentTabIndex = 0,
  });

  @override
  List<Object?> get props => [message, currentTabIndex];
}
