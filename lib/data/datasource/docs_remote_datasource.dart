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
    await Future.delayed(const Duration(milliseconds: 800));

    // Trả về Future.value để khớp với Future<DocumentEntity>
    return Future.value(
      DocumentEntity(
        title: "Báo Cáo Đồ Án Chuyên Ngành\n Trang web bán rượu - Treso'r de Levure",
        course: "Lập Trình .NET",
        school: "Trường Đại học Nông Lâm Tp. HCM",
        year: "2024/2025",
        uploader: "Subeo Dangiu",
        likes: 16,
        dislikes: 0,
        pages: 80,
        fileSize: "2.4 MB",
        comments: [
          CommentEntity(author: "Haruka", text: "Cảm ơn bro nhiều nha. Mà thời gian hoàn thành cả đồ án là bao lâu vậy."),
          CommentEntity(author: "Nguyen Van A", text: "Cần thêm giải thích chi tiết hơn cho phần backend."),
          CommentEntity(author: "Tran Thi B", text: "PDF tải về nhanh, chất lượng tốt, cảm ơn bạn!"),
          CommentEntity(author: "Le Van C", text: "Có ai biết tài liệu này có cập nhật mới không?"),
          CommentEntity(author: "Pham Thi D", text: "Rất phù hợp với môn học của tôi, thanks!"),
          CommentEntity(author: "Hoang Van E", text: "Tài liệu tuyệt vời, giúp mình hiểu rõ hơn về .NET."),
          CommentEntity(author: "Vu Thi F", text: "Mong có thêm tài liệu tương tự cho ASP.NET."),
        ],
      ),
    );
  }

  @override
  Future<void> toggleSave() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<void> downloadDocument() async {
    await Future.delayed(const Duration(milliseconds: 1000));
  }

  @override
  Future<void> toggleLike({required bool isLike}) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<void> postComment(String text) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}