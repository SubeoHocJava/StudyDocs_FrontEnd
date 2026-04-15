import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/sceens/user/document/domain/repository/document_repository.dart';
import 'package:studydocs/sceens/user/document/domain/usecase/get_documnet_usecase.dart';

import 'document_event.dart';
import 'document_state.dart';

class DocumentBloc extends Bloc<DocumentEvent, DocumentState> {
  DocumentBloc({required DocumentRepository documentRepository})
    : super(DocumentInitial()) {
    final GetDocumentUseCase getDocumentUseCase = GetDocumentUseCaseImpl(
      documentRepository,
    );

    on<GetDocumentRequested>((event, emit) async {
      emit(DocumentLoading());
      final document = await getDocumentUseCase.call(event.documentId);
      emit(DocumentLoaded(document: document));
    });
  }
}
