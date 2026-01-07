import 'dart:async';

import '../../../../core/network/dio_client.dart';
import '../../features/docs/domain/entity/document_entity.dart';

abstract class DocsRemoteDataSource {
  Future<DocumentEntity> getDocumentDetails();
  Future<void> toggleSave();
  Future<void> downloadDocument();
  Future<void> toggleLike({required bool isLike});
  Future<void> postComment(String text);
}

class DocsRemoteDataSourceImpl implements DocsRemoteDataSource {
  final DioClient dioClient;

  DocsRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<DocumentEntity> getDocumentDetails() async {
    await Future.delayed(const Duration(milliseconds: 800)); // Giả lập loading

    // DỮ LIỆU MẪU THẬT - URL CHUẨN TỪ BẠN CUNG CẤP
    const String baseUrl = "https://res.cloudinary.com/dzfynkkoc/image/upload/f_jpg,pg_1/rd4commsbz2vbzli4h3z"; // Chỉ giữ pg_1 làm mẫu
    const int totalPages = 5;
    const String fileName = "DeCuongTieuLuan_TranNhutAnh_22130915_09082025.pdf";
    const String downloadUrl = "https://res.cloudinary.com/dzfynkkoc/image/upload/fl_attachment/rd4commsbz2vbzli4h3z";

    // Generate đúng URL cho 5 trang
    List<String> previewUrls = [];
    for (int i = 1; i <= totalPages; i++) {
      String url = baseUrl.replaceAll("pg_1", "pg_$i");
      previewUrls.add(url);
    }

    // Comments mẫu
    final comments = [
      CommentEntity(author: "Haruka", text: "Cảm ơn bro nhiều nha. Mà thời gian hoàn thành cả đồ án là bao lâu vậy."),
      CommentEntity(author: "Nguyen Van A", text: "Cần thêm giải thích chi tiết hơn cho phần backend."),
      CommentEntity(author: "Tran Thi B", text: "PDF tải về nhanh, chất lượng tốt, cảm ơn bạn!"),
      CommentEntity(author: "Le Van C", text: "Có ai biết tài liệu này có cập nhật mới không?"),
      CommentEntity(author: "Pham Thi D", text: "Rất phù hợp với môn học của tôi, thanks!"),
      CommentEntity(author: "Hoang Van E", text: "Tài liệu tuyệt vời, giúp mình hiểu rõ hơn về .NET."),
      CommentEntity(author: "Vu Thi F", text: "Mong có thêm tài liệu tương tự cho ASP.NET."),
    ];

    return DocumentEntity(
      title: fileName.replaceAll('.pdf', ''),
      course: "Lập Trình .NET",
      school: "Trường Đại học Nông Lâm Tp. HCM",
      year: "2024/2025",
      uploader: "Subeo Dangiu",
      likes: 16,
      dislikes: 0,
      pages: totalPages,
      fileSize: "3.0 MB",
      downloadUrl: downloadUrl,
      previewUrls: previewUrls,
      comments: comments,
    );
  }

  @override
  Future<void> toggleSave() async => await Future.delayed(const Duration(milliseconds: 300));

  @override
  Future<void> downloadDocument() async => await Future.delayed(const Duration(milliseconds: 1000));

  @override
  Future<void> toggleLike({required bool isLike}) async => await Future.delayed(const Duration(milliseconds: 300));

  @override
  Future<void> postComment(String text) async => await Future.delayed(const Duration(milliseconds: 500));
}