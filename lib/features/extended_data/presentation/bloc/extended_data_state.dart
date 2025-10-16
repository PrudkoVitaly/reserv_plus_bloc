import 'package:equatable/equatable.dart';
import 'package:reserv_plus/features/extended_data/domain/entities/extended_data.dart';

abstract class ExtendedDataState extends Equatable {
  const ExtendedDataState();

  @override
  List<Object?> get props => [];
}

// Начальное состояние
class ExtendedDataInitial extends ExtendedDataState {
  const ExtendedDataInitial();
}

// Шаг 1: Подтверждение запроса
class ExtendedDataRequestConfirmation extends ExtendedDataState {
  const ExtendedDataRequestConfirmation();
}

// Загрузка после подтверждения
class ExtendedDataRequestInProgress extends ExtendedDataState {
  const ExtendedDataRequestInProgress();
}

// Шаг 2: Проверка данных
class ExtendedDataReviewScreen extends ExtendedDataState {
  final ExtendedData data;

  const ExtendedDataReviewScreen({required this.data});

  @override
  List<Object?> get props => [data];
}

// Шаг 3: Генерация PDF
class ExtendedDataGeneratingPDF extends ExtendedDataState {
  final ExtendedData data;

  const ExtendedDataGeneratingPDF({required this.data});

  @override
  List<Object?> get props => [data];
}

// Успех - PDF сгенерирован
class ExtendedDataSuccess extends ExtendedDataState {
  final String pdfPath;

  const ExtendedDataSuccess({required this.pdfPath});

  @override
  List<Object?> get props => [pdfPath];
}

// Ошибка
class ExtendedDataFailure extends ExtendedDataState {
  final String error;

  const ExtendedDataFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
