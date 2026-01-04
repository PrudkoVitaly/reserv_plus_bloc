import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/document_repository.dart';
import '../../data/services/document_share_service.dart';
import '../../data/services/document_pdf_generator.dart';
import 'document_event.dart';
import 'document_state.dart';

class DocumentBloc extends Bloc<DocumentEvent, DocumentState> {
  final DocumentRepository _repository;

  DocumentBloc({required DocumentRepository repository})
      : _repository = repository,
        super(const DocumentInitial()) {
    on<DocumentLoadData>(_onLoadData);
    on<DocumentFlipCard>(_onFlipCard);
    on<DocumentShowModal>(_onShowModal);
    on<DocumentHideModal>(_onHideModal);
    on<DocumentToggleModal>(_onToggleModal);
    on<DocumentUpdateData>(_onUpdateData);
    on<DocumentShareDocument>(_onShareDocument);
    on<DocumentCorrectDataOnline>(_onCorrectDataOnline);
    on<DocumentShowFullInfo>(_onShowFullInfo);
    // Добавить новые обработчики для сканирования QR
    on<ScanMilitaryDocumentQREvent>(_onScanMilitaryDocumentQR);
    on<ScanPaperSummonsQREvent>(_onScanPaperSummonsQR);
    on<ScanReferralQREvent>(_onScanReferralQR);
  }


  Future<void> _onLoadData(DocumentLoadData event, Emitter<DocumentState> emit) async {
    emit(const DocumentLoading());

    try {
      final data = await _repository.getDocumentData();
      emit(DocumentLoaded(data: data));
    } catch (e) {
      emit(DocumentError(e.toString()));
    }
  }

  Future<void> _onFlipCard(DocumentFlipCard event, Emitter<DocumentState> emit) async {
    if (state is DocumentLoaded) {
      final currentState = state as DocumentLoaded;
      emit(currentState.copyWith(
        isFlipping: true,
        isFrontVisible: !currentState.isFrontVisible,
      ));

      // Имитация анимации
      await Future.delayed(const Duration(milliseconds: 600));
      if (!emit.isDone && state is DocumentLoaded) {
        final updatedState = state as DocumentLoaded;
        emit(updatedState.copyWith(isFlipping: false));
      }
    }
  }

  void _onShowModal(DocumentShowModal event, Emitter<DocumentState> emit) {
    if (state is DocumentLoaded) {
      final currentState = state as DocumentLoaded;
      emit(currentState.copyWith(isModalVisible: true));
    }
  }

  void _onHideModal(DocumentHideModal event, Emitter<DocumentState> emit) {
    if (state is DocumentLoaded) {
      final currentState = state as DocumentLoaded;
      emit(currentState.copyWith(isModalVisible: false));
    }
  }

  Future<void> _onUpdateData(
      DocumentUpdateData event, Emitter<DocumentState> emit) async {
    if (state is DocumentLoaded) {
      final currentState = state as DocumentLoaded;
      emit(DocumentUpdating(currentState.data));

      try {
        final updatedData = await _repository.updateDocumentData();
        emit(DocumentLoaded(
          data: updatedData,
          isFrontVisible: currentState.isFrontVisible,
          isModalVisible: false,
        ));
      } catch (e) {
        emit(DocumentError(e.toString()));
      }
    }
  }

  Future<void> _onShareDocument(
      DocumentShareDocument event, Emitter<DocumentState> emit) async {
    try {
      if (state is DocumentLoaded) {
        final currentState = state as DocumentLoaded;
        final data = currentState.data;

        // Генерируем PDF файл
        final pdfFile = await DocumentPdfGenerator.generatePdf(
          fullName: data.fullName,
          birthDate: data.birthDate,
          status: data.status,
          validityDate: data.validityDate,
          qrCode: data.qrCode,
          lastUpdated: data.formattedLastUpdated,
        );

        // Делимся PDF файлом через системный Share Sheet
        await DocumentShareService.shareFile(
          filePath: pdfFile.path,
          text: 'Військово-обліковий документ',
          subject: 'Мій документ',
        );
      }
    } catch (e) {
      emit(DocumentError(e.toString()));
    }
  }

  Future<void> _onCorrectDataOnline(
      DocumentCorrectDataOnline event, Emitter<DocumentState> emit) async {
    try {
      await _repository.correctDataOnline();
      // Здесь можно показать уведомление об успешном исправлении
    } catch (e) {
      emit(DocumentError(e.toString()));
    }
  }

  void _onShowFullInfo(
      DocumentShowFullInfo event, Emitter<DocumentState> emit) {
    // Здесь можно добавить логику для показа полной информации
    // Например, навигацию на другой экран
  }

  void _onToggleModal(DocumentToggleModal event, Emitter<DocumentState> emit) {
    if (state is DocumentLoaded) {
      final currentState = state as DocumentLoaded;
      emit(currentState.copyWith(isModalVisible: event.isVisible));
    }
  }

  Future<void> _onScanMilitaryDocumentQR(
    ScanMilitaryDocumentQREvent event,
    Emitter<DocumentState> emit,
  ) async {
    // Эмитим состояние навигации
    emit(const DocumentNavigateToScanner(scanType: 'military'));
  }

  Future<void> _onScanPaperSummonsQR(
    ScanPaperSummonsQREvent event,
    Emitter<DocumentState> emit,
  ) async {
    emit(const DocumentNavigateToScanner(scanType: 'summons'));
  }

  Future<void> _onScanReferralQR(
    ScanReferralQREvent event,
    Emitter<DocumentState> emit,
  ) async {
    emit(const DocumentNavigateToScanner(scanType: 'referral'));
  }
}
