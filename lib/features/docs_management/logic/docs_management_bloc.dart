import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/usecase/get_my_docs_usecase.dart';
import '../domain/usecase/delete_doc_usecase.dart';
import '../domain/usecase/update_doc_usecase.dart';
import 'docs_management_event.dart';
import 'docs_management_state.dart';

class DocsManagementBloc extends Bloc<DocsManagementEvent, DocsManagementState> {
  final GetMyDocsUseCase getMyDocsUseCase;
  final DeleteDocUseCase deleteDocUseCase;
  final UpdateDocUseCase updateDocUseCase;

  DocsManagementBloc({
    required this.getMyDocsUseCase,
    required this.deleteDocUseCase,
    required this.updateDocUseCase,
  }) : super(DocsManagementInitial()) {
    on<LoadMyDocs>(_onLoadMyDocs);
    on<DeleteDocEvent>(_onDeleteDoc);
    on<UpdateDocEvent>(_onUpdateDoc);
  }

  Future<void> _onLoadMyDocs(
      LoadMyDocs event, Emitter<DocsManagementState> emit) async {
    emit(DocsManagementLoading());
    try {
      final docs = await getMyDocsUseCase();

      // Simple client-side filtering (mock)
      final filtered = docs.where((doc) {
        bool match = true;
        if (event.filterSchool != null && event.filterSchool!.isNotEmpty) {
          match = match && doc.school.contains(event.filterSchool!);
        }
        if (event.filterSubject != null && event.filterSubject!.isNotEmpty) {
          match = match && doc.course.contains(event.filterSubject!);
        }
        if (event.filterYear != null && event.filterYear!.isNotEmpty) {
          match = match && doc.year.contains(event.filterYear!);
        }
        return match;
      }).toList();

      emit(DocsManagementLoaded(filtered));
    } catch (e) {
      emit(DocsManagementError(e.toString()));
    }
  }

  Future<void> _onDeleteDoc(
      DeleteDocEvent event, Emitter<DocsManagementState> emit) async {
    if (state is DocsManagementLoaded) {
      final currentDocs = (state as DocsManagementLoaded).docs;
      
      // Optimistic Update
      final updatedDocs = List.of(currentDocs);
      updatedDocs.removeWhere((d) => d.title == event.docId); // Mock ID usage
      emit(DocsManagementLoaded(updatedDocs));

      try {
        await deleteDocUseCase(event.docId);
        // Success
      } catch (e) {
        // Revert
        emit(DocsManagementLoaded(currentDocs));
        emit(DocsManagementError("Failed to delete: $e"));
      }
    }
  }

  Future<void> _onUpdateDoc(
      UpdateDocEvent event, Emitter<DocsManagementState> emit) async {
    // Show Loading or remain loaded? Often better to show loading overlay or toast
    // For simplicity, we just process it.
    try {
      await updateDocUseCase(event.docId, event.updatedDoc);
      add(const LoadMyDocs()); // Reload to get fresh state
    } catch (e) {
      emit(DocsManagementError("Failed to update: $e"));
    }
  }
}
