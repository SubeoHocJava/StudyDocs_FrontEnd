class ImageUtils {
  static String? fixPdfThumbnail(String? url) {
    if (url == null || url.isEmpty) return url;
    if (url.toLowerCase().endsWith('.pdf')) {
      return '${url.substring(0, url.length - 4)}.jpg';
    }
    return url;
  }

  static String? getPagePreview(String? template, int page) {
    if (template == null || template.isEmpty) return template;
    if (template.contains('<<pageNumber>>')) {
      return template.replaceAll('<<pageNumber>>', page.toString());
    }
    // Backward compatibility
    if (template.toLowerCase().endsWith('.pdf')) {
      return '${template.substring(0, template.length - 4)}.jpg';
    }
    return template;
  }
}
