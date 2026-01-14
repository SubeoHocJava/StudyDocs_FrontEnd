import 'package:studydocs/features/media/data/model/asset_model.dart';

abstract class AssetRemoteDataSource {
  Future<AssetModel> getAssetById(String id);
}
