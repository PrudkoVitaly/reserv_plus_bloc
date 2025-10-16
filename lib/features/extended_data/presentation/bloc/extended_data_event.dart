import 'package:equatable/equatable.dart';

abstract class ExtendedDataEvent extends Equatable {
  const ExtendedDataEvent();

  @override
  List<Object?> get props => [];
}

// Инициализация процесса
class ExtendedDataInitialized extends ExtendedDataEvent {
  const ExtendedDataInitialized();
}

// Шаг 1: Подтверждение запроса
class ExtendedDataConfirmRequest extends ExtendedDataEvent {
  const ExtendedDataConfirmRequest();
}

// Шаг 2: Переход к проверке данных
class ExtendedDataProceedToReview extends ExtendedDataEvent {
  const ExtendedDataProceedToReview();
}

// Шаг 3: Генерация PDF
class ExtendedDataGeneratePDF extends ExtendedDataEvent {
  const ExtendedDataGeneratePDF();
}

// Отмена процесса
class ExtendedDataCancelled extends ExtendedDataEvent {
  const ExtendedDataCancelled();
}
