import 'package:equatable/equatable.dart';
import 'package:studydocs/screens/user/library/domain/entity/library_page_data.dart';

abstract class LibraryState extends Equatable {
  const LibraryState();

  @override
  List<Object?> get props => [];
}

class LibraryInitial extends LibraryState {
  const LibraryInitial();
}

class LibraryLoading extends LibraryState {
  const LibraryLoading();
}

class LibraryLoaded extends LibraryState {
  final LibraryPageData data;

  const LibraryLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class LibraryFailure extends LibraryState {
  final String message;

  const LibraryFailure(this.message);

  @override
  List<Object?> get props => [message];
}
