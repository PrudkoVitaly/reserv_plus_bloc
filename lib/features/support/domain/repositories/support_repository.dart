import 'package:reserv_plus/features/support/domain/entities/support_info.dart';

abstract class SupportRepository {
  Future<SupportInfo> getSupportInfo();
  Future<void> copyToClipboard(String text);
  Future<String> getDeviceNumber();
  Future<String> getViberUrl();
  Future<void> openUrl(String url);
}
