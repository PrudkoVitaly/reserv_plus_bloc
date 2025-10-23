import 'package:equatable/equatable.dart';
import '../../domain/entities/document_data.dart';

abstract class DocumentState extends Equatable {
  const DocumentState();

  @override
  List<Object?> get props => [];
}

class DocumentInitial extends DocumentState {
  const DocumentInitial();
}

class DocumentLoading extends DocumentState {
  const DocumentLoading();
}

class DocumentLoaded extends DocumentState {
  final DocumentData data;
  final bool isFrontVisible;
  final bool isModalVisible;
  final bool isFlipping;

  const DocumentLoaded({
    required this.data,
    this.isFrontVisible = true,
    this.isModalVisible = false,
    this.isFlipping = false,
  });

  DocumentLoaded copyWith({
    DocumentData? data,
    bool? isFrontVisible,
    bool? isModalVisible,
    bool? isFlipping,
  }) {
    return DocumentLoaded(
      data: data ?? this.data,
      isFrontVisible: isFrontVisible ?? this.isFrontVisible,
      isModalVisible: isModalVisible ?? this.isModalVisible,
      isFlipping: isFlipping ?? this.isFlipping,
    );
  }

  @override
  List<Object?> get props => [data, isFrontVisible, isModalVisible, isFlipping];
}

class DocumentError extends DocumentState {
  final String message;

  const DocumentError(this.message);

  @override
  List<Object?> get props => [message];
}

class DocumentUpdating extends DocumentState {
  final DocumentData data;

  const DocumentUpdating(this.data);

  @override
  List<Object?> get props => [data];
}


class DocumentNavigateToScanner extends DocumentState {
  final String scanType; // 'military', 'summons', 'referral'

  const DocumentNavigateToScanner({required this.scanType});

  @override
  List<Object?> get props => [scanType];
}
