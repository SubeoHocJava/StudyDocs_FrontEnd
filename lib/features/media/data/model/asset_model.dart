import 'package:equatable/equatable.dart';

class AssetModel extends Equatable {
  final String id;
  final String assetName;
  final int size;
  final String contentType;
  final int totalPages;
  final String downloadUrl;
  final String status;
  final int uploadProgress;
  // Ignoring PreviewData for now as structure is complex/undefined in projection snippet, 
  // can be added later if needed or mapped to Map<String, dynamic>
  final Map<String, dynamic>? previewData;

  const AssetModel({
    required this.id,
    required this.assetName,
    required this.size,
    required this.contentType,
    required this.totalPages,
    required this.downloadUrl,
    required this.status,
    required this.uploadProgress,
    this.previewData,
  });

  factory AssetModel.fromJson(Map<String, dynamic> json) {
    return AssetModel(
      id: json['id'] as String,
      assetName: json['assetName'] as String,
      size: json['size'] as int,
      contentType: json['contentType'] as String,
      totalPages: json['totalPages'] as int,
      downloadUrl: json['downloadUrl'] as String,
      status: json['status'] as String,
      uploadProgress: json['uploadProgress'] as int,
      previewData: json['previewData'] as Map<String, dynamic>?,
    );
  }

  @override
  List<Object?> get props => [
        id,
        assetName,
        size,
        contentType,
        totalPages,
        downloadUrl,
        status,
        uploadProgress,
        previewData,
      ];
}
