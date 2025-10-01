import 'package:equatable/equatable.dart';

abstract class DocumentEvent extends Equatable {
  const DocumentEvent();

  @override
  List<Object?> get props => [];
}

class DocumentLoadData extends DocumentEvent {
  const DocumentLoadData();
}

class DocumentFlipCard extends DocumentEvent {
  const DocumentFlipCard();
}

class DocumentShowModal extends DocumentEvent {
  const DocumentShowModal();
}

class DocumentHideModal extends DocumentEvent {
  const DocumentHideModal();
}

class DocumentUpdateData extends DocumentEvent {
  const DocumentUpdateData();
}

class DocumentDownloadPdf extends DocumentEvent {
  const DocumentDownloadPdf();
}

class DocumentCorrectDataOnline extends DocumentEvent {
  const DocumentCorrectDataOnline();
}

class DocumentShowFullInfo extends DocumentEvent {
  const DocumentShowFullInfo();
}

class DocumentToggleModal extends DocumentEvent {
  final bool isVisible;
  const DocumentToggleModal(this.isVisible);

  @override
  List<Object?> get props => [isVisible];
}
