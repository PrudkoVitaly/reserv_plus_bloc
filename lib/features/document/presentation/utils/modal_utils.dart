import 'package:flutter/material.dart';
import 'package:reserv_plus/features/document/presentation/widgets/document_scan_options_modal.dart';
import 'package:reserv_plus/features/document/presentation/widgets/document_update_modal.dart';
import '../widgets/document_modal_dialog.dart';

class ModalUtils {
  // Показывает модальное окно для выбора документа
  static void showDocumentModal(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const DocumentModalDialog(),
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 150),
        opaque: false,
        barrierDismissible: true,
        barrierColor: Colors.black.withValues(alpha: 0.5),
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
        barrierColor: Colors.black.withValues(alpha: 0.5),
      ),
    );
  }

  // Показывает модальное окно для обновления документа
  static void showDocumentUpdateModal(BuildContext context) {
    showDocumentUpdateModalWithNavigator(Navigator.of(context));
  }

  // Показывает модальное окно для обновления документа с переданным navigator
  static void showDocumentUpdateModalWithNavigator(NavigatorState navigator) {
    navigator.push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const DocumentUpdateModal(),
        transitionDuration: const Duration(milliseconds: 300),
        
        opaque: false,
        barrierDismissible: true,
        barrierColor: Colors.black.withValues(alpha: 0.5),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Такая же анимация как у других модалов
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 0.1),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              )),
              child: child,
            ),
          );
        },
      ),
    );
  }
}
