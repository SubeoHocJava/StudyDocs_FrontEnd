import 'package:studydocs/data/model/document_model/response/document_summary_model.dart';

abstract class ProfileDocumentsState {}

class ProfileDocumentsInitial extends ProfileDocumentsState {}

class ProfileDocumentsLoading extends ProfileDocumentsState {}

class ProfileDocumentsLoaded extends ProfileDocumentsState {
  final List<DocumentSummaryModel> documents;

  ProfileDocumentsLoaded(this.documents);
}

class ProfileDocumentsError extends ProfileDocumentsState {
  final String message;

  ProfileDocumentsError(this.message);
}
