import 'package:equatable/equatable.dart';
import '../../domain/entities/navigation_state.dart';

abstract class MainState extends Equatable {
  const MainState();

  @override
  List<Object?> get props => [];
}

class MainInitial extends MainState {
  const MainInitial();
}

class MainLoading extends MainState {
  const MainLoading();
}

class MainLoaded extends MainState {
  final NavigationState navigationState;

  const MainLoaded(this.navigationState);

  @override
  List<Object?> get props => [navigationState];
}

class MainError extends MainState {
  final String message;

  const MainError(this.message);

  @override
  List<Object?> get props => [message];
}
