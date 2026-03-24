import 'package:equatable/equatable.dart';
import 'package:studydocs/core/widgets/feat/document/overview/domain/entity/document_overview.dart';

abstract class DocumentOverviewState extends Equatable {
  const DocumentOverviewState();

  @override
  List<Object?> get props => [];
}

class DocumentOverviewInitial extends DocumentOverviewState {}

class DocumentOverviewLoaded extends DocumentOverviewState {
  final DocumentOverview documentOverview;
  final String? downloadUrl;

  const DocumentOverviewLoaded({
    required this.documentOverview,
    this.downloadUrl,
  });

  @override
  List<Object?> get props => [documentOverview, downloadUrl];
}
