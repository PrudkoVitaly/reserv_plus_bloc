import 'package:equatable/equatable.dart';

class RegistryData extends Equatable {
  final String? fullName;
  final String? status;
  final String? registrationNumber;
  final String? birthDate;
  final String? address;
  final bool hasNotifications;

  const RegistryData({
    this.fullName,
    this.status,
    this.registrationNumber,
    this.birthDate,
    this.address,
    this.hasNotifications = false,
  });

  @override
  List<Object?> get props => [
        fullName,
        status,
        registrationNumber,
        birthDate,
        address,
        hasNotifications,
      ];
}
