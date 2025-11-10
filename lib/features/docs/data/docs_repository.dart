class DocsRepository {
  Future<Map<String, dynamic>> getDocDetails() async {
    await Future.delayed(const Duration(milliseconds: 800)); // giả lập API nhanh

    return {
      "title": "Báo Cáo Đồ Án Chuyên Ngành\nTrang web bán rượu - Treso'r de Levure",
      "course": "Lập Trình .NET",
      "school": "Trường Đại học Nông Lâm Tp. HCM",
      "year": "2024/2025",
      "uploader": "Subeo Dangiu",
      "likes": 16,
      "dislikes": 0,
      "comments": [
        {
          "author": "Haruka",
          "text": "Cảm ơn bro nhiều nha. Mà thời gian hoàn thành cả đồ án là bao lâu vậy.",
        },
        {
          "author": "Nguyen Van A",
          "text": "Cần thêm giải thích chi tiết hơn cho phần backend.",
        },
        {
          "author": "Tran Thi B",
          "text": "PDF tải về nhanh, chất lượng tốt, cảm ơn bạn!",
        },
        {
          "author": "Le Van C",
          "text": "Có ai biết tài liệu này có cập nhật mới không?",
        },
        {
          "author": "Pham Thi D",
          "text": "Rất phù hợp với môn học của tôi, thanks!",
        },
        {
          "author": "Hoang Van E",
          "text": "Tài liệu tuyệt vời, giúp mình hiểu rõ hơn về .NET.",
        },
        {
          "author": "Vu Thi F",
          "text": "Mong có thêm tài liệu tương tự cho ASP.NET.",
        },
      ]
    };
  }
}