import 'package:equatable/equatable.dart';
import 'package:studydocs/features/model/Document.dart';

abstract class LibraryState extends Equatable {
  const LibraryState();
  @override
  List<Object?> get props => [];
}
class LibraryInitial extends LibraryState{
}
class LibraryLoading extends LibraryState{

}
class LibraryLoaded extends LibraryState {
  final List<Document> documents;
  final List<String> categories;
  final filePick;

  const LibraryLoaded(this.documents, this.categories, this.filePick);

  @override
  List<Object?> get props => [documents, categories];
}

class LibraryError extends LibraryState{
  final String message;

  const LibraryError(this.message);

}