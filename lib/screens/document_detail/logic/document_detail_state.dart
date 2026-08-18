import 'package:equatable/equatable.dart';
import 'package:studydocs/screens/document_detail/domain/entity/document_detail_data.dart';

abstract class DocumentDetailState extends Equatable {
  const DocumentDetailState();

  @override
  List<Object?> get props => [];
}

class DocumentDetailInitial extends DocumentDetailState {}

class DocumentDetailLoading extends DocumentDetailState {}

class DocumentDetailLoaded extends DocumentDetailState {
  final DocumentDetailData data;
  
  const DocumentDetailLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class DocumentDetailError extends DocumentDetailState {
  final String message;
  
  const DocumentDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
