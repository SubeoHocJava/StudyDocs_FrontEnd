import 'package:equatable/equatable.dart';
import 'package:studydocs/features/subject_library/domain/entity/DocumentEntity.dart';



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
  final List<DocumentEntity> uploaded_docs;
  final List<DocumentEntity> the_most_liked_docs;
  final List<DocumentEntity> documents;

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
