import 'package:equatable/equatable.dart';
import 'package:studydocs/core/widgets/feat/document/information/domain/entity/document_info.dart';

abstract class DocumentInformationState extends Equatable {
  const DocumentInformationState();

  @override
  List<Object> get props => [];
}

class DocumentInformationInitial extends DocumentInformationState {}

class DocumentInformationLoaded extends DocumentInformationState {
  final DocumentInfo documentInfo;

  const DocumentInformationLoaded(this.documentInfo);

  @override
  List<Object> get props => [documentInfo];
}
