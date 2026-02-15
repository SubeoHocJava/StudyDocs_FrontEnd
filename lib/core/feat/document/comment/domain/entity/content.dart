sealed class ContentBlock {}

class TextBlock extends ContentBlock {
  final String text;

  TextBlock(this.text);
}

// Triển khai sau
// class ImageBlock extends ContentBlock {
//   final String imageUrl;
//   ImageBlock(this.imageUrl);
// }
//
// class VideoBlock extends ContentBlock {
//   final String videoUrl;
//   VideoBlock(this.videoUrl);
// }
