import 'package:equatable/equatable.dart';
import 'package:studydocs/screens/user/library/domain/entity/library_subject_page_data.dart';

abstract class LibrarySubjectState extends Equatable {
  const LibrarySubjectState();

  @override
  List<Object?> get props => [];
}

class LibrarySubjectInitial extends LibrarySubjectState {
  const LibrarySubjectInitial();
}

class LibrarySubjectLoading extends LibrarySubjectState {
  const LibrarySubjectLoading();
}

class LibrarySubjectLoaded extends LibrarySubjectState {
  final LibrarySubjectPageData data;

  const LibrarySubjectLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class LibrarySubjectFailure extends LibrarySubjectState {
  final String message;

  const LibrarySubjectFailure(this.message);

  @override
  List<Object?> get props => [message];
}
