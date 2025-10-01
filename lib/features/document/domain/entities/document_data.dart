import 'package:equatable/equatable.dart';

class DocumentData extends Equatable {
  final String fullName;
  final String firstName;
  final String lastName;
  final String patronymic;
  final String birthDate;
  final String status;
  final String validityDate;
  final String qrCode;
  final DateTime lastUpdated;
  final String formattedLastUpdated;
  final bool isDataUpToDate;

  const DocumentData({
    required this.fullName,
    required this.firstName,
    required this.lastName,
    required this.patronymic,
    required this.birthDate,
    required this.status,
    required this.validityDate,
    required this.qrCode,
    required this.lastUpdated,
    required this.formattedLastUpdated,
    this.isDataUpToDate = true,
  });

  @override
  List<Object?> get props => [
        fullName,
        firstName,
        lastName,
        patronymic,
        birthDate,
        status,
        validityDate,
        qrCode,
        lastUpdated,
        formattedLastUpdated,
        isDataUpToDate,
      ];
}
