import 'package:equatable/equatable.dart';

sealed class ContentBlock extends Equatable {
  const ContentBlock();
}

class TextBlock extends ContentBlock {
  final String text;

  const TextBlock(this.text);

  @override
  List<Object?> get props => [text];
}

// Triển khai sau
// class ImageBlock extends ContentBlock {
//   final String imageUrl;
//   const ImageBlock(this.imageUrl);
//   @override
//   List<Object?> get props => [imageUrl];
// }
//
// class VideoBlock extends ContentBlock {
//   final String videoUrl;
//   const VideoBlock(this.videoUrl);
//   @override
//   List<Object?> get props => [videoUrl];
// }
