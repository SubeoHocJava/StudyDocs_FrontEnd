import 'package:studydocs/core/constants/api_constants.dart';
import 'package:studydocs/core/network/dio_client.dart';
import 'package:studydocs/core/widgets/feat/common/folder_list/domain/entity/folder_item.dart';
import 'package:studydocs/core/widgets/feat/document/docs_card/domain/repository/document_repository.dart';
import 'package:studydocs/data/model/document_model/response/document_compact_model.dart';
import 'package:studydocs/data/model/document_model/response/document_summary_model.dart';
import 'package:studydocs/screens/user/library/domain/entity/library_page_data.dart';
import 'package:studydocs/screens/user/library/domain/entity/library_subject_page_data.dart';
import 'package:studydocs/screens/user/library/domain/repository/library_repository.dart';

class LibraryRemoteRepository implements LibraryRepository, DocumentRepository {
  final DioClient _client;

  LibraryRemoteRepository({DioClient? client}) : _client = client ?? DioClient();

  List? _extractList(dynamic responseData) {
    if (responseData is List) return responseData;
    if (responseData is Map) {
      if (responseData['items'] is List) return responseData['items'] as List;
      if (responseData['data'] is List) return responseData['data'] as List;
      if (responseData['data'] is Map && responseData['data']['items'] is List) {
        return responseData['data']['items'] as List;
      }
    }
    return null;
  }

  @override
  Future<LibraryPageData> getLibraryPage() async {
    List<FolderItem> subjects = [];
    List<DocumentCompactModel> recent = [];
    List<DocumentSummaryModel> saved = [];

    try {
      final resSubjects = await _client.get('universities');
      if (resSubjects.isSuccess && resSubjects.data != null) {
        final dataList = _extractList(resSubjects.data);
        if (dataList != null) {
          subjects = dataList.map((e) {
            final map = Map<String, dynamic>.from(e as Map);
            // FolderItem expects id, title
            return FolderItem(
              id: map['uuid']?.toString() ?? map['id']?.toString() ?? '',
              title: map['name']?.toString() ?? map['title']?.toString() ?? '',
            );
          }).toList();
        }
      }
    } catch (_) {}

    try {
      final resRecent = await _client.get('documents');
      if (resRecent.isSuccess && resRecent.data != null) {
        final dataList = _extractList(resRecent.data);
        if (dataList != null) {
          recent = dataList.map((e) {
            final map = Map<String, dynamic>.from(e as Map);
            return DocumentCompactModel(
              id: map['id']?.toString() ?? '',
              title: map['title']?.toString() ?? '',
              thumbnail: map['thumbnail']?.toString(),
            );
          }).toList();
        }
      }
    } catch (_) {}

    try {
      final resSaved = await _client.get('documents');
      if (resSaved.isSuccess && resSaved.data != null) {
        final dataList = _extractList(resSaved.data);
        if (dataList != null) {
          saved = dataList.map((e) {
             try {
                return DocumentSummaryModel.fromJson(Map<String, dynamic>.from(e as Map));
             } catch (_) {
                // Return a fallback or skip if parsing fails
                final map = Map<String, dynamic>.from(e as Map);
                return DocumentSummaryModel(
                  id: map['id']?.toString() ?? '',
                  title: map['title']?.toString() ?? '',
                  school: map['school']?.toString() ?? map['universityName']?.toString() ?? '',
                  year: map['year']?.toString() ?? '',
                  category: map['category']?.toString() ?? map['subjectName']?.toString() ?? '',
                  pageCount: map['pageCount'] as int? ?? 0,
                  likeCount: map['likeCount'] as int? ?? 0,
                  commentCount: map['commentCount'] as int? ?? 0,
                  thumbnail: map['thumbnail']?.toString(),
                  isBookmarked: map['isBookmarked'] as bool? ?? false,
                );
             }
          }).toList();
        }
      }
    } catch (_) {}

    return LibraryPageData(
      subjects: subjects,
      recentDocuments: recent,
      savedDocuments: saved,
    );
  }

  @override
  Future<LibrarySubjectPageData> getLibrarySubjectPage(String subjectId) async {
    String schoolName = 'Trường Đại học Nông Lâm Tp. HCM';
    String subjectName = 'Môn học';

    try {
      final resSubjectInfo = await _client.get('universities/$subjectId');
      if (resSubjectInfo.isSuccess && resSubjectInfo.data != null) {
         final data = resSubjectInfo.data is Map ? resSubjectInfo.data['data'] ?? resSubjectInfo.data : resSubjectInfo.data;
         if (data is Map) {
            subjectName = data['name']?.toString() ?? data['title']?.toString() ?? subjectName;
         }
      }
    } catch (_) {}

    List<DocumentCompactModel> uploaded = [];
    List<DocumentSummaryModel> stored = [];

    try {
       final resUserDocs = await _client.get('documents');
       if (resUserDocs.isSuccess && resUserDocs.data != null) {
          final dataList = _extractList(resUserDocs.data);
          if (dataList != null) {
            uploaded = dataList.map((e) {
               final map = Map<String, dynamic>.from(e as Map);
               return DocumentCompactModel(
                  id: map['id']?.toString() ?? '',
                  title: map['title']?.toString() ?? '',
                  thumbnail: map['thumbnail']?.toString(),
               );
            }).toList();

            stored = dataList.map((e) {
               try {
                  return DocumentSummaryModel.fromJson(Map<String, dynamic>.from(e as Map));
               } catch (_) {
                  final map = Map<String, dynamic>.from(e as Map);
                  return DocumentSummaryModel(
                    id: map['id']?.toString() ?? '',
                    title: map['title']?.toString() ?? '',
                    school: map['school']?.toString() ?? map['universityName']?.toString() ?? '',
                    year: map['year']?.toString() ?? '',
                    category: map['category']?.toString() ?? map['subjectName']?.toString() ?? '',
                    pageCount: map['pageCount'] as int? ?? 0,
                    likeCount: map['likeCount'] as int? ?? 0,
                    commentCount: map['commentCount'] as int? ?? 0,
                    thumbnail: map['thumbnail']?.toString(),
                    isBookmarked: map['isBookmarked'] as bool? ?? false,
                  );
               }
            }).toList();
          }
       }
    } catch (_) {}

    return LibrarySubjectPageData(
      subjectId: subjectId,
      schoolName: schoolName,
      subjectName: subjectName,
      userCount: 0,
      uploadedDocuments: uploaded,
      topLikedDocuments: uploaded.reversed.toList(),
      storedDocuments: stored,
    );
  }

  @override
  Future<String?> like(String documentId) async {
    try {
      final res = await _client.post('documents/$documentId/interactions', data: {'type': 'LIKE'});
      return res.isSuccess ? null : 'Failed to like';
    } catch (e) {
      return e.toString();
    }
  }

  @override
  Future<String?> bookmark(String documentId) async {
    try {
      final res = await _client.post('${DocumentEndpoints.base}/$documentId/bookmark');
      return res.isSuccess ? null : 'Failed to bookmark';
    } catch (e) {
      return e.toString();
    }
  }

  @override
  Future<String?> download(String documentId) async {
    try {
      final res = await _client.post('${DocumentEndpoints.base}/$documentId/download');
      return res.isSuccess ? null : 'Failed to download';
    } catch (e) {
      return e.toString();
    }
  }
}
