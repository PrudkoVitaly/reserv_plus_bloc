import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/document_repository.dart';
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
    on<DocumentDownloadPdf>(_onDownloadPdf);
    on<DocumentCorrectDataOnline>(_onCorrectDataOnline);
    on<DocumentShowFullInfo>(_onShowFullInfo);
  }

  void _onLoadData(DocumentLoadData event, Emitter<DocumentState> emit) async {
    emit(const DocumentLoading());

    try {
      final data = await _repository.getDocumentData();
      emit(DocumentLoaded(data: data));
    } catch (e) {
      emit(DocumentError(e.toString()));
    }
  }

  void _onFlipCard(DocumentFlipCard event, Emitter<DocumentState> emit) {
    if (state is DocumentLoaded) {
      final currentState = state as DocumentLoaded;
      emit(currentState.copyWith(
        isFlipping: true,
        isFrontVisible: !currentState.isFrontVisible,
      ));

      // Имитация анимации
      Future.delayed(const Duration(milliseconds: 600), () {
        if (state is DocumentLoaded) {
          final updatedState = state as DocumentLoaded;
          emit(updatedState.copyWith(isFlipping: false));
        }
      });
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

  void _onUpdateData(
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

  void _onDownloadPdf(
      DocumentDownloadPdf event, Emitter<DocumentState> emit) async {
    try {
      await _repository.downloadPdf();
      // Здесь можно показать уведомление об успешном скачивании
    } catch (e) {
      emit(DocumentError(e.toString()));
    }
  }

  void _onCorrectDataOnline(
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
}
