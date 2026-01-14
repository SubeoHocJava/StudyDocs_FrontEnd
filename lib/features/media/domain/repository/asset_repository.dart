import 'package:studydocs/features/media/domain/entity/asset_entity.dart';

abstract class AssetRepository {
  Future<AssetEntity> getAssetById(String id);
}
