import 'package:equatable/equatable.dart';

abstract class SupportEvent extends Equatable {
  const SupportEvent();

  @override
  List<Object?> get props => [];
}

class SupportInitialized extends SupportEvent {
  const SupportInitialized();
}

class SupportCopyDeviceNumber extends SupportEvent {
  const SupportCopyDeviceNumber();
}

class SupportOpenViber extends SupportEvent {
  const SupportOpenViber();
}
