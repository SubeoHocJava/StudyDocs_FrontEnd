import 'package:studydocs/data/model/document_model.dart';
import '../domain/ui_model/doc_subject_lib_ui.dart';

extension DocumentMapper on DocumentModel {
  DocumentSubjectLibUI toUI() {
    return DocumentSubjectLibUI(
      id: id,
      title: title,
      category: category ?? 'Không rõ',
      institution: institution ?? 'Không rõ',
      pages: pageCount ?? 0,
      createdAt: createdAt ?? '',
      likesCount: likesCount ?? 0,
      commentsCount: commentsCount ?? 0,
      thumbnailUrl: thumbnailUrl,
      isLiked: false,
      isSaved: false,
    );
  }
}
