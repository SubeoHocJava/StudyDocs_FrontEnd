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
  final String school;
  final String subject;
  final int num_friends;
  final int num_docs;
  final List<DocumentSubjectLibUI> uploaded_docs;
  final List<DocumentSubjectLibUI> the_most_liked_docs;
  final List<DocumentSubjectLibUI> documents;
  final List<SubjectEntity> subjects;

  const SubjectLibraryLoaded(
    this.subject,
    this.uploaded_docs,
    this.the_most_liked_docs,
    this.documents,
    this.school,
    this.num_friends,
    this.num_docs,
    this.subjects,
  );

  @override
  List<Object?> get props => [uploaded_docs, the_most_liked_docs, subjects];
}

class SubjectLibraryError extends SubjectLibraryState {
  final String message;

  const SubjectLibraryError(this.message);
}
