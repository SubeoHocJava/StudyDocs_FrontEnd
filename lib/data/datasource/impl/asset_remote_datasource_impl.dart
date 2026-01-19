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
    } catch (e) {
      // Rethrow to let repository handle it
      throw Exception('Failed to load asset: $e');
    }
  }
}
