import '/features/docs/domain/entity/document_entity.dart';
import '/features/docs/domain/repository/docs_repository.dart';

/// Triển khai lớp DocsRepository
/// Mô phỏng việc lấy dữ liệu từ backend bằng Future + delay
class DocsRepositoryImpl implements DocsRepository {

  /// Giả lập API lấy thông tin chi tiết tài liệu
  /// Trả về DocumentEntity chứa metadata + comments
  @override
  Future<DocumentEntity> getDocumentDetails() async {
    // Delay để mô phỏng call API thật
    await Future.delayed(const Duration(milliseconds: 800));

    // Trả về dữ liệu mock
    return DocumentEntity(
      title: "Báo Cáo Đồ Án Chuyên Ngành\nTrang web bán rượu - Treso'r de Levure",
      course: "Lập Trình .NET",
      school: "Trường Đại học Nông Lâm Tp. HCM",
      year: "2024/2025",
      uploader: "Subeo Dangiu",
      likes: 16,
      dislikes: 0,
      comments: [
        CommentEntity(author: "Haruka", text: "Cảm ơn bro nhiều nha. Mà thời gian hoàn thành cả đồ án là bao lâu vậy."),
        CommentEntity(author: "Nguyen Van A", text: "Cần thêm giải thích chi tiết hơn cho phần backend."),
        CommentEntity(author: "Tran Thi B", text: "PDF tải về nhanh, chất lượng tốt, cảm ơn bạn!"),
        CommentEntity(author: "Le Van C", text: "Có ai biết tài liệu này có cập nhật mới không?"),
        CommentEntity(author: "Pham Thi D", text: "Rất phù hợp với môn học của tôi, thanks!"),
        CommentEntity(author: "Hoang Van E", text: "Tài liệu tuyệt vời, giúp mình hiểu rõ hơn về .NET."),
        CommentEntity(author: "Vu Thi F", text: "Mong có thêm tài liệu tương tự cho ASP.NET."),
      ],
    );
  }

  /// Giả lập hành động lưu/huỷ lưu tài liệu
  /// Backend thực sẽ cập nhật trạng thái trong DB
  @override
  Future<void> toggleSave() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
