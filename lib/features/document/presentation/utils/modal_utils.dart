import 'package:flutter/material.dart';
import 'package:reserv_plus/features/document/presentation/widgets/document_scan_options_modal.dart';
import '../widgets/document_modal_dialog.dart';

class ModalUtils {
  // Показывает модальное окно для выбора документа
  static void showDocumentModal(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const DocumentModalDialog(),
        transitionDuration: const Duration(milliseconds: 300),
        opaque: false,
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.5),
      ),
    );
  }

  // Показывает модальное для опций сканирования
  static void showDocumentScanOptions(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const DocumentScanOptionsModal(),
        transitionDuration: const Duration(milliseconds: 300),
        opaque: false,
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.5),
      ),
    );
  }
}
