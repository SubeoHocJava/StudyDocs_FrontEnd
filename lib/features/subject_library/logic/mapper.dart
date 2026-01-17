import 'package:studydocs/features/docs/data/model/document_model.dart';
import '../domain/ui_model/doc_subject_lib_ui.dart';

extension DocumentMapper on DocumentModel {
  DocumentSubjectLibUI toUI() {
    return DocumentSubjectLibUI(
      id: id ?? '',
      title: title,
      category: this.course,
      institution: this.school,
      pages: this.pages, // Correct field
      createdAt: this.year, // Correct field
      likesCount: this.likes,
      commentsCount: this.comments.length,
      thumbnailUrl: this.previewUrls.isNotEmpty ? this.previewUrls.first : null,
      isLiked: this.currentUserReaction == 'LIKE',
      isSaved: this.isSaved,
    );
  }
}
