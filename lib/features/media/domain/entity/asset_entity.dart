import 'package:equatable/equatable.dart';
import 'package:studydocs/features/media/data/model/asset_model.dart';

class AssetEntity extends Equatable {
  final String id;
  final String assetName;
  final int size;
  final String contentType;
  final int totalPages;
  final String downloadUrl;
  final String status;
  final int uploadProgress;
  final Map<String, dynamic>? previewData;

  const AssetEntity({
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

  factory AssetEntity.fromModel(AssetModel model) {
    return AssetEntity(
      id: model.id,
      assetName: model.assetName,
      size: model.size,
      contentType: model.contentType,
      totalPages: model.totalPages,
      downloadUrl: model.downloadUrl,
      status: model.status,
      uploadProgress: model.uploadProgress,
      previewData: model.previewData,
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
