import 'package:equatable/equatable.dart';

abstract class DocsCardItemEvent extends Equatable {
  const DocsCardItemEvent();

  @override
  List<Object?> get props => [];
}

class CardLiked extends DocsCardItemEvent {
  const CardLiked();
}

class CardBookmarked extends DocsCardItemEvent {
  const CardBookmarked();
}

class CardDownloaded extends DocsCardItemEvent {
  const CardDownloaded();
}

class CardErrorCleared extends DocsCardItemEvent {
  const CardErrorCleared();
}

class CardSyncUpdated extends DocsCardItemEvent {
  final bool? isBookmarked;
  final bool? isLiked;
  final int? newLikeCount;
  final int? newCommentCount;

  const CardSyncUpdated({
    this.isBookmarked,
    this.isLiked,
    this.newLikeCount,
    this.newCommentCount,
  });

  @override
  List<Object?> get props => [isBookmarked, isLiked, newLikeCount, newCommentCount];
}
