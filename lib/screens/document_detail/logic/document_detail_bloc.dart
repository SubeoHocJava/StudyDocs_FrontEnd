import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/screens/document_detail/domain/repository/document_detail_repository.dart';
import 'document_detail_event.dart';
import 'document_detail_state.dart';

class DocumentDetailBloc extends Bloc<DocumentDetailEvent, DocumentDetailState> {
  final DocumentDetailRepository repository;

  DocumentDetailBloc({required this.repository}) : super(DocumentDetailInitial()) {
    on<DocumentDetailRequested>(_onRequested);
  }

  Future<void> _onRequested(
    DocumentDetailRequested event,
    Emitter<DocumentDetailState> emit,
  ) async {
    emit(DocumentDetailLoading());
    try {
      final data = await repository.getDocumentDetail(event.documentId);
      emit(DocumentDetailLoaded(data));
    } catch (e) {
      emit(DocumentDetailError(e.toString()));
    }
  }
}
