import 'package:reserv_plus/features/extended_data/domain/entities/extended_data.dart';

abstract class ExtendedDataRepository {
  Future<ExtendedData> getExtendedData();
  Future<bool> requestExtendedData();
  Future<String> generatePDF();
}
