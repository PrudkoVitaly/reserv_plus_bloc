import '../../domain/repositories/request_sent_repository.dart';

class RequestSentRepositoryImpl implements RequestSentRepository {
  @override
  Future<void> logRequestSent() async {
    // Имитация логирования отправки запроса
    await Future.delayed(const Duration(milliseconds: 500));
    // Здесь может быть логика отправки аналитики или сохранения в локальную БД
  }
}
