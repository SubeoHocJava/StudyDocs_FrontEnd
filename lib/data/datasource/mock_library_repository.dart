import 'package:studydocs/core/widgets/feat/common/folder_list/domain/entity/folder_item.dart';
import 'package:studydocs/core/widgets/feat/document/docs_card/domain/repository/document_repository.dart';
import 'package:studydocs/data/model/document_model/response/document_compact_model.dart';
import 'package:studydocs/data/model/document_model/response/document_summary_model.dart';
import 'package:studydocs/screens/user/library/domain/entity/library_page_data.dart';
import 'package:studydocs/screens/user/library/domain/entity/library_subject_page_data.dart';
import 'package:studydocs/screens/user/library/domain/repository/library_repository.dart';

class MockLibraryRepository implements LibraryRepository, DocumentRepository {
  static const _mockDelay = Duration(milliseconds: 250);
  static const _schoolName = 'Trường Đại học Nông Lâm Tp. HCM';

  const MockLibraryRepository();

  @override
  Future<LibraryPageData> getLibraryPage() async {
    await Future<void>.delayed(_mockDelay);
    return LibraryPageData(
      subjects: _subjects,
      recentDocuments: _compactDocuments,
      savedDocuments: _summaryDocuments,
    );
  }

  @override
  Future<LibrarySubjectPageData> getLibrarySubjectPage(String subjectId) async {
    await Future<void>.delayed(_mockDelay);
    final selectedSubject = _subjects.firstWhere(
      (subject) => subject.id == subjectId,
      orElse: () => _subjects.first,
    );

    final uploadedDocuments = _compactDocuments
        .where((document) => _matchesSubject(selectedSubject.title, document.title))
        .toList(growable: false);
    final storedDocuments = _summaryDocuments
        .where((document) => _matchesSubject(selectedSubject.title, document.category))
        .toList(growable: false);

    final resolvedUploaded = uploadedDocuments.isNotEmpty
        ? uploadedDocuments
        : _compactDocuments.take(3).toList(growable: false);
    final resolvedStored = storedDocuments.isNotEmpty
        ? storedDocuments
        : _summaryDocuments.toList(growable: false);

    return LibrarySubjectPageData(
      subjectId: selectedSubject.id,
      schoolName: _schoolName,
      subjectName: selectedSubject.title,
      userCount: 16,
      uploadedDocuments: resolvedUploaded,
      topLikedDocuments: resolvedUploaded.reversed.toList(growable: false),
      storedDocuments: resolvedStored,
    );
  }

  @override
  Future<String?> like(String documentId) async {
    await Future<void>.delayed(_mockDelay);
    return null;
  }

  @override
  Future<String?> bookmark(String documentId) async {
    await Future<void>.delayed(_mockDelay);
    return null;
  }

  @override
  Future<String?> download(String documentId) async {
    await Future<void>.delayed(_mockDelay);
    return null;
  }

  static bool _matchesSubject(String subjectName, String sourceText) {
    final subject = subjectName.toLowerCase();
    final source = sourceText.toLowerCase();

    if (subject.contains('.net')) return source.contains('.net');
    if (subject.contains('web')) return source.contains('web');
    if (subject.contains('an toàn')) return source.contains('an toàn');
    return source.contains('công nghệ') || source.contains('thông tin');
  }

  static const _subjects = [
    FolderItem(id: 'subj-1', title: 'Công nghệ phần mềm'),
    FolderItem(id: 'subj-2', title: 'An toàn và bảo mật hệ thống thông tin'),
    FolderItem(id: 'subj-3', title: 'Lập trình .NET'),
  ];

  static const _summaryDocuments = [
    DocumentSummaryModel(
      id: 'doc-1',
      title: 'Báo cáo đồ án chuyên ngành trang web bán rượu - Tresor de Levure',
      thumbnail: 'assets/images/tai-lieu.jpg',
      category: 'Lập trình .NET',
      school: _schoolName,
      pageCount: 19,
      year: '2024/2025',
      likeCount: 15,
      commentCount: 3,
    ),
    DocumentSummaryModel(
      id: 'doc-2',
      title: 'Báo cáo thực tập tốt nghiệp hệ thống quản lý sinh viên',
      thumbnail: 'assets/images/tai-lieu.jpg',
      category: 'Công nghệ thông tin',
      school: _schoolName,
      pageCount: 45,
      year: '2023/2024',
      likeCount: 28,
      commentCount: 7,
      isBookmarked: true,
    ),
    DocumentSummaryModel(
      id: 'doc-3',
      title: 'Đồ án lập trình Web - Ứng dụng đặt hàng online',
      thumbnail: 'assets/images/tai-lieu.jpg',
      category: 'Lập trình Web',
      school: _schoolName,
      pageCount: 32,
      year: '2024/2025',
      likeCount: 10,
      commentCount: 2,
    ),
  ];

  static const _compactDocuments = [
    DocumentCompactModel(
      id: 'doc-1',
      title: 'Báo cáo đồ án chuyên ngành trang web bán rượu',
      thumbnail: 'assets/images/tai-lieu.jpg',
    ),
    DocumentCompactModel(
      id: 'doc-2',
      title: 'Báo cáo thực tập tốt nghiệp',
      thumbnail: 'assets/images/tai-lieu.jpg',
    ),
    DocumentCompactModel(
      id: 'doc-3',
      title: 'Đồ án lập trình Web',
      thumbnail: 'assets/images/tai-lieu.jpg',
    ),
    DocumentCompactModel(
      id: 'doc-4',
      title: 'Tiểu luận cơ sở dữ liệu',
      thumbnail: 'assets/images/tai-lieu.jpg',
    ),
    DocumentCompactModel(
      id: 'doc-5',
      title: 'Báo cáo an toàn thông tin',
      thumbnail: 'assets/images/tai-lieu.jpg',
    ),
  ];
}
