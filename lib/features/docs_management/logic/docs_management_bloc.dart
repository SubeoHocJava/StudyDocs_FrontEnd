import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/usecase/get_my_docs_usecase.dart';
import '../domain/usecase/get_all_docs_usecase.dart';
import '../domain/usecase/delete_doc_usecase.dart';
import '../domain/usecase/delete_admin_doc_usecase.dart';
import '../domain/usecase/update_doc_usecase.dart';
import '../domain/usecase/upload_doc_usecase.dart';
import 'docs_management_event.dart';
import 'docs_management_state.dart';

class DocsManagementBloc extends Bloc<DocsManagementEvent, DocsManagementState> {
  final GetMyDocsUseCase getMyDocsUseCase;
  final GetAllDocsUseCase? getAllDocsUseCase;
  final DeleteDocUseCase deleteDocUseCase;
  final DeleteAdminDocUseCase? deleteAdminDocUseCase;
  final UpdateDocUseCase updateDocUseCase;
  final UploadDocUseCase uploadDocUseCase;

  DocsManagementBloc({
    required this.getMyDocsUseCase,
    this.getAllDocsUseCase,
    required this.deleteDocUseCase,
    this.deleteAdminDocUseCase,
    required this.updateDocUseCase,
    required this.uploadDocUseCase,
  }) : super(DocsManagementInitial()) {
    on<LoadMyDocs>(_onLoadMyDocs);
    on<LoadAllDocs>(_onLoadAllDocs);
    on<DeleteDocEvent>(_onDeleteDoc);
    on<DeleteAdminDocEvent>(_onDeleteAdminDoc);
    on<UpdateDocEvent>(_onUpdateDoc);
    on<UploadDocEvent>(_onUploadDoc);
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

  Future<void> _onLoadAllDocs(
      LoadAllDocs event, Emitter<DocsManagementState> emit) async {
    emit(DocsManagementLoading());
    try {
      if (getAllDocsUseCase == null) {
        throw Exception("GetAllDocsUseCase not provided");
      }
      final docs = await getAllDocsUseCase!();

      // Simple client-side filtering (mock) - reuse logic or extract
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
      updatedDocs.removeWhere((d) => d.id == event.docId);
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

  Future<void> _onDeleteAdminDoc(
      DeleteAdminDocEvent event, Emitter<DocsManagementState> emit) async {
     if (state is DocsManagementLoaded) {
      final currentDocs = (state as DocsManagementLoaded).docs;
      
      // Optimistic Update
      final updatedDocs = List.of(currentDocs);
      updatedDocs.removeWhere((d) => d.id == event.docId);
      emit(DocsManagementLoaded(updatedDocs));

      try {
        if (deleteAdminDocUseCase != null) {
           await deleteAdminDocUseCase!(event.docId);
        } else {
           throw Exception("DeleteAdminDocUseCase not provided");
        }
      } catch (e) {
        // Revert
        emit(DocsManagementLoaded(currentDocs));
        emit(DocsManagementError("Failed to delete (Admin): $e"));
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

  Future<void> _onUploadDoc(
      UploadDocEvent event, Emitter<DocsManagementState> emit) async {
    try {
      await uploadDocUseCase(event.file, event.metadata);
      add(const LoadMyDocs()); // Reload list
    } catch (e) {
      emit(DocsManagementError("Failed to upload: $e"));
    }
  }
}
