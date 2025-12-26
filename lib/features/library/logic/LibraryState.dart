import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:studydocs/features/library/domain/model/document_library.dart';

abstract class LibraryState extends Equatable {
  const LibraryState();

  @override
  List<Object?> get props => [];
}

class LibraryInitial extends LibraryState {}

class LibraryLoading extends LibraryState {}

class LibraryLoaded extends LibraryState {
  final List<DocumentLibraryUI> documents;
  final List<String> categories;
  final PlatformFile? pickedFile;

  const LibraryLoaded({
    required this.documents,
    required this.categories,
    this.pickedFile,
  });

  LibraryLoaded copyWith({
    List<DocumentLibraryUI>? documents,
    List<String>? categories,
    PlatformFile? pickedFile,
  }) {
    return LibraryLoaded(
      documents: documents ?? this.documents,
      categories: categories ?? this.categories,
      pickedFile: pickedFile,
    );
  }

  @override
  List<Object?> get props => [documents, categories, pickedFile];
}

class LibraryError extends LibraryState {
  final String message;

  const LibraryError(this.message);

  @override
  List<Object?> get props => [message];
}
