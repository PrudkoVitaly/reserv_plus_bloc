import 'package:reserv_plus/features/forgot_pin/domain/entities/forgot_pin_data.dart';

abstract class ForgotPinRepository {
  Future<ForgotPinData> getForgotPinData();
  Future<void> requestReAuthorization();
}
