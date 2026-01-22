import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reserv_plus/features/extended_data/domain/repositories/extended_data_repository.dart';
import 'package:reserv_plus/features/extended_data/presentation/bloc/extended_data_event.dart';
import 'package:reserv_plus/features/extended_data/presentation/bloc/extended_data_state.dart';

class ExtendedDataBloc extends Bloc<ExtendedDataEvent, ExtendedDataState> {
  final ExtendedDataRepository _repository;

  ExtendedDataBloc({required ExtendedDataRepository repository})
      : _repository = repository,
        super(const ExtendedDataRequestConfirmation()) {
    on<ExtendedDataInitialized>(_onInitialized);
    on<ExtendedDataConfirmRequest>(_onConfirmRequest);
    on<ExtendedDataProceedToReview>(_onProceedToReview);
    on<ExtendedDataGeneratePDF>(_onGeneratePDF);
    on<ExtendedDataCancelled>(_onCancelled);
  }

  // Шаг 1: Показываем экран подтверждения
  Future<void> _onInitialized(
    ExtendedDataInitialized event,
    Emitter<ExtendedDataState> emit,
  ) async {
    emit(const ExtendedDataRequestConfirmation());
  }

  // Шаг 2: Отправляем запрос и загружаем данные
  Future<void> _onConfirmRequest(
    ExtendedDataConfirmRequest event,
    Emitter<ExtendedDataState> emit,
  ) async {
    try {
      // Отправляем запрос
      await _repository.requestExtendedData();

      // Получаем данные
      final data = await _repository.getExtendedData();

      // Переходим к экрану проверки данных (без loading экрана)
      emit(ExtendedDataReviewScreen(data: data));
    } catch (e) {
      emit(ExtendedDataFailure(error: e.toString()));
    }
  }

  // Переход к следующему шагу (пока не используется)
  Future<void> _onProceedToReview(
    ExtendedDataProceedToReview event,
    Emitter<ExtendedDataState> emit,
  ) async {
    // Логика для перехода между шагами если нужно
  }

  // Шаг 3: Генерируем PDF
  Future<void> _onGeneratePDF(
    ExtendedDataGeneratePDF event,
    Emitter<ExtendedDataState> emit,
  ) async {
    if (state is ExtendedDataReviewScreen) {
      final currentData = (state as ExtendedDataReviewScreen).data;

      emit(ExtendedDataGeneratingPDF(data: currentData));

      try {
        final pdfPath = await _repository.generatePDF();
        emit(ExtendedDataSuccess(pdfPath: pdfPath));
      } catch (e) {
        emit(ExtendedDataFailure(error: e.toString()));
      }
    }
  }

  // Отмена процесса
  void _onCancelled(
    ExtendedDataCancelled event,
    Emitter<ExtendedDataState> emit,
  ) {
    emit(const ExtendedDataInitial());
  }
}
