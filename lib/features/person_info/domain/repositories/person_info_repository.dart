import '../entities/person_info.dart';

abstract class PersonInfoRepository {
  Future<PersonInfo> getPersonInfo();
}
