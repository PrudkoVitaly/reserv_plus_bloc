import 'package:flutter/material.dart';
import '../widgets/document_modal_dialog.dart';

class ModalUtils {
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
}
