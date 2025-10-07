import '../entities/person_info.dart';
import '../repositories/person_info_repository.dart';

class GetPersonInfo {
  final PersonInfoRepository repository;

  GetPersonInfo(this.repository);

  Future<PersonInfo> call() async {
    return await repository.getPersonInfo();
  }
}
