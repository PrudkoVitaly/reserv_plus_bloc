import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:reserv_plus/features/support/domain/entities/support_info.dart';
import 'package:reserv_plus/features/support/domain/repositories/support_repository.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportRepositoryImpl implements SupportRepository {
  static const String _defaultViberUrl = 'https://www.viber.com/ru/';
  static const String _defaultPhoneNumber = '0800501234';

  String? _cachedDeviceNumber;

  @override
  Future<SupportInfo> getSupportInfo() async {
    try {
      final deviceNumber = await getDeviceNumber();
      final viberUrl = await getViberUrl();

      return SupportInfo(
        deviceNumber: deviceNumber,
        viberUrl: viberUrl,
        phoneNumber: _defaultPhoneNumber,
      );
    } catch (e) {
      throw Exception('Помилка отримання інформації підтримки: $e');
    }
  }

  @override
  Future<void> copyToClipboard(String text) async {
    try {
      await Clipboard.setData(ClipboardData(text: text));
    } catch (e) {
      throw Exception('Помилка копіювання в буфер обміну: $e');
    }
  }

  @override
Future<String> getDeviceNumber() async {
  if (_cachedDeviceNumber != null) {
    return _cachedDeviceNumber!;
  }
  try {
    final deviceInfo = DeviceInfoPlugin();
    
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      _cachedDeviceNumber = androidInfo.id;
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      _cachedDeviceNumber = iosInfo.identifierForVendor ?? 'UNKNOWN';
    } else {
      _cachedDeviceNumber = 'DEVICE-${DateTime.now().millisecondsSinceEpoch}';
    }
    
    return _cachedDeviceNumber!;
  } catch (e) {
    throw Exception('Помилка отримання номера пристрою: $e');
  }
}

  @override
  Future<String> getViberUrl() async {
    await Future.delayed(const Duration(milliseconds: 50));

    return _defaultViberUrl;
  }

  @override
  Future<void> openUrl(String url) async {
    try {
      final uri = Uri.parse(url);

      if (!await canLaunchUrl(uri)) {
        throw Exception('Не вдалося відкрити URL: $url');
      }

      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      throw Exception('Помилка відкриття URL: $e');
    }
  }
}
