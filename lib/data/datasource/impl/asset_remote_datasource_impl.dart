import 'package:studydocs/core/network/dio_client.dart';
import 'package:studydocs/data/datasource/asset_remote_datasource.dart';
import 'package:studydocs/features/media/data/model/asset_model.dart';

class AssetRemoteDataSourceImpl implements AssetRemoteDataSource {
  final DioClient dioClient;

  AssetRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<AssetModel> getAssetById(String id) async {
    try{    final response = await dioClient.get('/assets/$id');
    return AssetModel.fromJson(response.data);
    }
    catch(err)
{
  return  AssetModel(
    id: "asset_001",
    assetName: "sample_document.pdf",
    size: 2456789,
    contentType: "application/pdf",
    totalPages: 3,
    downloadUrl: "https://picsum.photos/seed/download/800/600",
    status: "COMPLETED",
    uploadProgress: 100,
      previewData: {
      "baseUrl": "https://picsum.photos/seed/page_{page}/800/600",
      "key": "{page}"
    }
  );
    }
  }
}
