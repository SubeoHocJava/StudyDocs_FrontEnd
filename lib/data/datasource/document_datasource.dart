import 'package:studydocs/core/widgets/feat/document/docs_card/domain/repository/document_repository.dart';
import 'package:studydocs/data/model/document_model/response/document_compact_model.dart';
import 'package:studydocs/data/model/document_model/response/document_summary_model.dart';

/// Fake datasource — giả lập dữ liệu mẫu thay vì gọi API thật.
/// Implement DocumentRepository để UseCase/Bloc gọi like/bookmark/download.
/// Khi có API: tạo class mới implement DocumentRepository, page và widget KHÔNG đổi.
class DocumentDatasource implements DocumentRepository {
  List<DocumentSummaryModel> getDocumentSummaryList() => [
    const DocumentSummaryModel(
      id: '1',
      title:
          'Báo Cáo Đồ Án Chuyên Ngành Trang web bán rượu - Treso\'r de Levure',
      thumbnail: 'assets/images/tai-lieu.jpg',
      category: 'Lập trình .NET',
      school: 'Trường Đại học Nông Lâm Tp. HCM',
      pageCount: 19,
      year: '2024/2025',
      likeCount: 15,
      commentCount: 3,
    ),
    const DocumentSummaryModel(
      id: '2',
      title: 'Báo Cáo Thực Tập Tốt Nghiệp Hệ Thống Quản Lý Sinh Viên',
      thumbnail: 'assets/images/tai-lieu.jpg',
      category: 'Công nghệ thông tin',
      school: 'Trường Đại học Nông Lâm Tp. HCM',
      pageCount: 45,
      year: '2023/2024',
      likeCount: 28,
      commentCount: 7,
    ),
    const DocumentSummaryModel(
      id: '3',
      title: 'Đồ Án Lập Trình Web - Ứng Dụng Đặt Hàng Online',
      thumbnail: 'assets/images/tai-lieu.jpg',
      category: 'Lập trình Web',
      school: 'Trường Đại học Nông Lâm Tp. HCM',
      pageCount: 32,
      year: '2024/2025',
      likeCount: 10,
      commentCount: 2,
    ),
  ];

  List<DocumentCompactModel> getDocumentCompactList() => [
    const DocumentCompactModel(
      id: '1',
      title: 'Báo Cáo Đồ Án Chuyên Ngành Trang web bán rượu',
      thumbnail: 'assets/images/tai-lieu.jpg',
    ),
    const DocumentCompactModel(
      id: '2',
      title: 'Báo Cáo Thực Tập Tốt Nghiệp',
      thumbnail: 'assets/images/tai-lieu.jpg',
    ),
    const DocumentCompactModel(
      id: '3',
      title: 'Đồ Án Lập Trình Web',
      thumbnail: 'assets/images/tai-lieu.jpg',
    ),
    const DocumentCompactModel(
      id: '4',
      title: 'Tiểu Luận Cơ Sở Dữ Liệu',
      thumbnail: 'assets/images/tai-lieu.jpg',
    ),
    const DocumentCompactModel(
      id: '5',
      title: 'Báo Cáo An Toàn Thông Tin',
      thumbnail: 'assets/images/tai-lieu.jpg',
    ),
  ];

  // --- DocumentRepository: giả lập gọi API, trả về null = thành công, mã lỗi = thất bại ---

  @override
  Future<String?> like(String documentId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Giả lập: luôn thành công. Để test revert: uncomment dòng dưới.
    // if (documentId == '2') return 'LIKE_FAILED';
    return null;
  }

  @override
  Future<String?> bookmark(String documentId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return null;
  }

  @override
  Future<String?> download(String documentId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return null;
  }
}
