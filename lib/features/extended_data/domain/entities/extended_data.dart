import 'package:equatable/equatable.dart';
import 'package:reserv_plus/features/shared/services/user_data_service.dart';

class ExtendedData extends Equatable {
  final String fullName;
  final String firstName;
  final String lastName;
  final String patronymic;
  final String birthDate;
  final String gender;
  final String taxId;
  final String status;
  final String placeOfBirth;
  final String address;
  final String phone;
  final String email;

  const ExtendedData({
    required this.fullName,
    required this.firstName,
    required this.lastName,
    required this.patronymic,
    required this.birthDate,
    required this.gender,
    required this.taxId,
    required this.status,
    required this.placeOfBirth,
    required this.address,
    required this.phone,
    required this.email,
  });

  factory ExtendedData.fromUserData() {
    final userData = UserDataService();
    return ExtendedData(
      fullName: userData.fullName,
      firstName: userData.firstName,
      lastName: userData.lastName,
      patronymic: userData.patronymic,
      birthDate: userData.birthDate,
      gender: userData.gender,
      taxId: userData.taxId,
      status: userData.status,
      placeOfBirth: userData.placeOfBirth,
      address: userData.address,
      phone: userData.phone,
      email: userData.email,
    );
  }

  @override
  List<Object?> get props => [
        fullName,
        firstName,
        lastName,
        patronymic,
        birthDate,
        gender,
        taxId,
        status,
        placeOfBirth,
        address,
        phone,
        email,
      ];
}
