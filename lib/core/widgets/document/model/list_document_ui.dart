import 'package:equatable/equatable.dart';

abstract class DocumentUiList extends Equatable {
  /// ===== ID =====
  String get id;
  String? get fileId;

  /// ===== BASIC INFO =====
  String get title;
  String? get category;
  String? get institution;
  String? get createdAt;
  int get pageCount;

  /// ===== MEDIA =====
  String? get thumbnailUrl;

  /// ===== STATS =====
  int get likesCount;
  int get commentsCount;

  /// ===== USER STATE =====
  bool get isLiked;
  bool get isSaved;

  const DocumentUiList();

  @override
  List<Object?> get props => [
    id,
    title,
    category,
    institution,
    createdAt,
    pageCount,
    thumbnailUrl,
    likesCount,
    commentsCount,
    isLiked,
    isSaved,
  ];
}
