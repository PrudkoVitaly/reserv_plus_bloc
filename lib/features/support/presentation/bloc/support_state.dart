import 'package:equatable/equatable.dart';

abstract class SupportState extends Equatable {
  const SupportState();

  @override
  List<Object?> get props => [];
}

class SupportInitial extends SupportState {
  const SupportInitial();
}

class SupportLoaded extends SupportState {
  const SupportLoaded();
}

class SupportCopyingNumber extends SupportState {
  const SupportCopyingNumber();
}

class SupportNumberCopied extends SupportState {
  final String message;

  const SupportNumberCopied({required this.message});

  @override
  List<Object?> get props => [message];
}

class SupportOpeningViber extends SupportState {
  const SupportOpeningViber();
}

class SupportViberOpened extends SupportState {
  const SupportViberOpened();
}

class SupportError extends SupportState {
  final String message;

  const SupportError({required this.message});

  @override
  List<Object?> get props => [message];
}
