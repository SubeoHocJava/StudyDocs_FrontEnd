import 'package:equatable/equatable.dart';

abstract class LibrarySubjectEvent extends Equatable {
  const LibrarySubjectEvent();

  @override
  List<Object?> get props => [];
}

class LibrarySubjectRequested extends LibrarySubjectEvent {
  final String subjectId;

  const LibrarySubjectRequested(this.subjectId);

  @override
  List<Object?> get props => [subjectId];
}
