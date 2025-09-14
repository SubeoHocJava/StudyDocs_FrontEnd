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
          "text":
          "Cảm ơn bro nhiều nha. Mà thời gian hoàn thành cả đồ án là bao lâu vậy.",
        }
      ]
    };
  }
}
