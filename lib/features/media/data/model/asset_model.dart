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
      previewData: json['previewDataView'] as Map<String, dynamic>?,
    );
  }

  List<String> get previewUrls {
    List<String> urls = [];
    if (previewData != null && totalPages > 0) {
      final baseUrl = previewData!['baseUrl'] as String?;
      final key = previewData!['key'] as String?;

      if (baseUrl != null && key != null) {
        for (int i = 1; i <= totalPages; i++) {
          String url = baseUrl.replaceAll(key, i.toString());
          if (!url.endsWith('.jpg') && !url.endsWith('.png')) {
            url = '$url.jpg';
          }
          urls.add(url);
        }
      }
    }
    return urls;
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
