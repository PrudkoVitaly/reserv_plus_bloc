import 'package:reserv_plus/features/forgot_pin/domain/entities/forgot_pin_data.dart';
import 'package:reserv_plus/features/forgot_pin/domain/repositories/forgot_pin_repository.dart';

class ForgotPinRepositoryImpl implements ForgotPinRepository {
  @override
  Future<ForgotPinData> getForgotPinData() async {
    return const ForgotPinData(
      title: 'Забули код для входу?',
      description: 'Пройдіть повторну авторизацію у застосунку',
      authorizeButtonText: 'Авторизуватися',
      cancelButtonText: 'Скасувати',
    );
  }

  @override
  Future<bool> requestReAuthorization() async {
    // Пока просто возвращаем true (в будущем здесь будет реальная логика)
    await Future.delayed(const Duration(seconds: 2));
    return true;
  }
}
