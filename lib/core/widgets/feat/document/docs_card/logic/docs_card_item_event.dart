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

/// Event nội bộ — clear lastError sau khi UI đã hiển thị SnackBar.
class CardErrorCleared extends DocsCardItemEvent {
  const CardErrorCleared();
}
