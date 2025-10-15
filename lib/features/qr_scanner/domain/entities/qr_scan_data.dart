class QRScanData {
  final String rawData;
  final bool isValid;
  final DateTime scanTime;
  final String? errorMessage;

  const QRScanData({
    required this.rawData,
    required this.isValid,
    required this.scanTime,
    this.errorMessage,
  });
}
