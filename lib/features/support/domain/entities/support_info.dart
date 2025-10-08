import 'package:equatable/equatable.dart';

class SupportInfo extends Equatable {
   final String deviceNumber;
   final String viberUrl;
   final String? phoneNumber;

   const SupportInfo({
    required this.deviceNumber,
    required this.viberUrl,
    this.phoneNumber,
  });

  factory SupportInfo.empty() {
    return const SupportInfo(
      deviceNumber: '',
      viberUrl: '',
      phoneNumber: null,
    );
  }

  @override
  List<Object?> get props => [deviceNumber, viberUrl, phoneNumber];
}