import 'package:equatable/equatable.dart';
import 'package:studydocs/core/feat/document/overview/domain/entity/document_overview.dart';

abstract class DocumentOverviewEvent extends Equatable {
  const DocumentOverviewEvent();

  @override
  List<Object?> get props => [];
}

class DocumentOverviewDataReceived extends DocumentOverviewEvent {
  final DocumentOverview documentOverview;

  const DocumentOverviewDataReceived({required this.documentOverview});
}

class DocumentSave extends DocumentOverviewEvent {
  final String id;

  const DocumentSave({required this.id});
}

class DocumentUnSave extends DocumentOverviewEvent {
  final String id;

  const DocumentUnSave({required this.id});
}

class DocumentDownloadRequested extends DocumentOverviewEvent {
  final String id;

  const DocumentDownloadRequested({required this.id});
}