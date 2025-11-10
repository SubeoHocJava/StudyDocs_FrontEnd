import 'package:equatable/equatable.dart';

abstract class DocsState extends Equatable {
  const DocsState();
  @override
  List<Object?> get props => [];
}

class DocsInitial extends DocsState {}

class DocsLoading extends DocsState {}

class DocsLoaded extends DocsState {
  final Map<String, dynamic> docDetails;
  final bool isSaved;
  const DocsLoaded(this.docDetails, {this.isSaved = false});

  @override
  List<Object?> get props => [docDetails, isSaved];
}

class DocsError extends DocsState {
  final String message;
  const DocsError(this.message);
  @override
  List<Object?> get props => [message];
}
