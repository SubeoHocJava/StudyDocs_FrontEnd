import 'package:equatable/equatable.dart';
import 'package:studydocs/features/model/Document.dart';

abstract class SubjectLibraryState extends Equatable {
  const SubjectLibraryState();
  @override
  List<Object?> get props => [];
}
class SubjectLibraryInitial extends SubjectLibraryState{
}
class SubjectLibraryLoading extends SubjectLibraryState{

}
class SubjectLibraryLoaded extends SubjectLibraryState {
  final List<Document> uploaded_docs;
  final List<Document> the_most_liked_docs;
  final List<Document> documents;
  final String subject;

  const SubjectLibraryLoaded(this.subject,this.uploaded_docs, this.the_most_liked_docs,this.documents);

  @override
  List<Object?> get props => [uploaded_docs, the_most_liked_docs];
}

class SubjectLibraryError extends SubjectLibraryState{
  final String message;

  const SubjectLibraryError(this.message);

}