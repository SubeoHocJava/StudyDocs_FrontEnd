import 'package:flutter_bloc/flutter_bloc.dart';

abstract class DocumentSyncEvent {}

class DocumentBookmarkToggled extends DocumentSyncEvent {
  final String documentId;
  final bool isBookmarked;

  DocumentBookmarkToggled(this.documentId, this.isBookmarked);
}

class DocumentLikeToggled extends DocumentSyncEvent {
  final String documentId;
  final bool isLiked;
  final int newLikeCount;

  DocumentLikeToggled(this.documentId, this.isLiked, this.newLikeCount);
}

class DocumentCommentCountUpdated extends DocumentSyncEvent {
  final String documentId;
  final int newCommentCount;

  DocumentCommentCountUpdated(this.documentId, this.newCommentCount);
}

class DocumentSyncState {
  final DocumentSyncEvent? lastEvent;

  DocumentSyncState({this.lastEvent});
}

class DocumentSyncCubit extends Cubit<DocumentSyncState> {
  DocumentSyncCubit() : super(DocumentSyncState());

  void toggleBookmark(String documentId, bool isBookmarked) {
    emit(DocumentSyncState(
      lastEvent: DocumentBookmarkToggled(documentId, isBookmarked),
    ));
  }

  void toggleLike(String documentId, bool isLiked, int newLikeCount) {
    emit(DocumentSyncState(
      lastEvent: DocumentLikeToggled(documentId, isLiked, newLikeCount),
    ));
  }
  void updateCommentCount(String documentId, int newCount) {
    emit(DocumentSyncState(
      lastEvent: DocumentCommentCountUpdated(documentId, newCount),
    ));
  }
}
