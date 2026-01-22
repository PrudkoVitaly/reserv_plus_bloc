import 'package:reserv_plus/features/extended_data/domain/entities/extended_data.dart';
import 'package:reserv_plus/features/extended_data/domain/repositories/extended_data_repository.dart';
import '../services/extended_data_pdf_generator.dart';

class ExtendedDataRepositoryImpl implements ExtendedDataRepository {
  @override
  Future<ExtendedData> getExtendedData() async {
    return ExtendedData.fromUserData();
  }

  @override
  Future<bool> requestExtendedData() async {
    return true;
  }

  @override
  Future<String> generatePDF() async {
    // Получаем данные для PDF
    final data = await getExtendedData();

    // Генерируем PDF
    final pdfPath =
        await ExtendedDataPdfGenerator.generateExtendedDataPDF(data);

    return pdfPath;
  }
}
