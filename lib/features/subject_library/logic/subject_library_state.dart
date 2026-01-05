import 'package:equatable/equatable.dart';
import '../domain/ui_model/doc_subject_lib_ui.dart';



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

  const SubjectLibraryLoaded(
    this.subject,
    this.uploaded_docs,
    this.the_most_liked_docs,
    this.documents,
    this.school,
    this.num_friends,
    this.num_docs,
  );

  @override
  List<Object?> get props => [uploaded_docs, the_most_liked_docs];
}

class SubjectLibraryError extends SubjectLibraryState {
  final String message;

  const SubjectLibraryError(this.message);
}
