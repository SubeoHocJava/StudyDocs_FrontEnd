import 'package:studydocs/core/network/dio_client.dart';
import 'package:studydocs/features/media/data/datasource/asset_remote_datasource.dart';
import 'package:studydocs/features/media/data/model/asset_model.dart';

class AssetRemoteDataSourceImpl implements AssetRemoteDataSource {
  final DioClient dioClient;

  AssetRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<AssetModel> getAssetById(String id) async {
    final response = await dioClient.get('/assets/$id');
    return AssetModel.fromJson(response.data);
  }
}
