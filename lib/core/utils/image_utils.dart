class ImageUtils {
  static String? fixPdfThumbnail(String? url) {
    if (url == null || url.isEmpty) return url;
    if (url.toLowerCase().endsWith('.pdf')) {
      return url.substring(0, url.length - 4) + '.jpg';
    }
    return url;
  }
}
