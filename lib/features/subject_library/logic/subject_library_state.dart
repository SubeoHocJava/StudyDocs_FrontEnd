import 'package:equatable/equatable.dart';
import '../domain/ui_model/doc_subject_lib_ui.dart';
import '../domain/entity/subject_entity.dart';



abstract class SubjectLibraryState extends Equatable {
  const SubjectLibraryState();

  @override
  List<Object?> get props => [];
}

class SubjectLibraryInitial extends SubjectLibraryState {}

class SubjectLibraryLoading extends SubjectLibraryState {}

class SubjectLibraryLoaded extends SubjectLibraryState {
  final String? schoolId;
  final String? subjectId; // Added for refresh support
  final String schoolName;
  final String subjectName;
  final int num_friends;
  final int num_docs;
  final List<DocumentSubjectLibUI> uploaded_docs;
  final List<DocumentSubjectLibUI> the_most_liked_docs;
  final List<DocumentSubjectLibUI> documents;
  final List<SubjectEntity> subjects;

  const SubjectLibraryLoaded({
    this.schoolId,
    this.subjectId, // Added
    required this.schoolName,
    required this.subjectName,
    this.num_friends = 0,
    this.num_docs = 0,
    required this.uploaded_docs,
    required this.the_most_liked_docs,
    required this.documents,
    required this.subjects,
  });

  @override
  List<Object?> get props => [
        schoolId,
        subjectId, // Added
        schoolName,
        subjectName,
        uploaded_docs,
        the_most_liked_docs,
        subjects,
        documents
      ];
}

class SubjectLibraryError extends SubjectLibraryState {
  final String message;

  const SubjectLibraryError(this.message);
}
