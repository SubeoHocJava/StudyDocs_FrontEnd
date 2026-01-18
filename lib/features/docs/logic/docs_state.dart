import 'package:equatable/equatable.dart';
import '../domain/entity/document_entity.dart';

/// State chung của DocsBloc
abstract class DocsState extends Equatable {
  const DocsState();
  @override
  List<Object?> get props => [];

  /// State mặc định không có save
  bool get isSaved => false;
}

/// State ban đầu
class DocsInitial extends DocsState {}

/// State đang loading
class DocsLoading extends DocsState {}

/// State đã load xong
class DocsLoaded extends DocsState {
  final DocumentEntity docDetails;
  @override
  final bool isSaved;

  const DocsLoaded(this.docDetails, {this.isSaved = false});

  DocsLoaded copyWith({
    DocumentEntity? docDetails,
    bool? isSaved,
  }) {
    return DocsLoaded(
      docDetails ?? this.docDetails,
      isSaved: isSaved ?? this.isSaved,
    );
  }

  @override
  List<Object?> get props => [docDetails, isSaved];
}

/// State lỗi
class DocsError extends DocsState {
  final String message;

  const DocsError(this.message);

  @override
  List<Object?> get props => [message];
}
