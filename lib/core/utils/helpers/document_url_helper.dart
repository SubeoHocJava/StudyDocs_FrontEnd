class DocumentUrlHelper {
  /// Lấy URL Thumbnail (Trang 1) từ previewDataView
  ///
  /// Logic:
  /// 1. Kiểm tra previewDataView có tồn tại và có baseUrl không
  /// 2. Thay thế `PAGE_NUMBER_PLACEHOLDER` bằng '1'
  /// 3. Nếu không có, trả về fallbackThumbnailUrl hoặc null
  static String? getThumbnailUrl({
    required dynamic previewDataView,
    String? fallbackThumbnailUrl,
    String? fileId,
  }) {
    if (previewDataView != null && previewDataView is Map) {
      final baseUrl = previewDataView['baseUrl'];
      if (baseUrl != null) {
        // Thay thế placeholder để lấy ảnh trang 1
        String url = baseUrl.toString().replaceAll(
          'PAGE_NUMBER_PLACEHOLDER',
          '1',
        );

        // Force JPG format for Cloudinary if missing extension
        if (!url.toLowerCase().endsWith('.jpg') &&
            !url.toLowerCase().endsWith('.png') &&
            !url.toLowerCase().endsWith('.jpeg')) {
          return "$url.jpg";
        }
        return url;
      }
    }

    if (fallbackThumbnailUrl != null && fallbackThumbnailUrl.isNotEmpty) {
      return fallbackThumbnailUrl;
    }

    return null;
  }

  /// Lấy danh sách URL cho tất cả các trang (Dùng cho màn xem chi tiết)
  static List<String> getPreviewUrls({
    required dynamic previewDataView,
    required int totalPages,
  }) {
    if (previewDataView == null ||
        previewDataView is! Map ||
        previewDataView['baseUrl'] == null) {
      return [];
    }

    final String baseUrl = previewDataView['baseUrl'].toString();
    final List<String> urls = [];

    for (int i = 1; i <= totalPages; i++) {
      String url = baseUrl.replaceAll('PAGE_NUMBER_PLACEHOLDER', '$i');
      // Force JPG format if missing
      if (!url.toLowerCase().endsWith('.jpg') &&
          !url.toLowerCase().endsWith('.png') &&
          !url.toLowerCase().endsWith('.jpeg')) {
        url = "$url.jpg";
      }
      urls.add(url);
    }
    return urls;
  }
}
