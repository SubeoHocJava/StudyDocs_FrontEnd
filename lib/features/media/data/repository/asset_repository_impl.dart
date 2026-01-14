import 'package:studydocs/data/datasource/asset_remote_datasource.dart';
import 'package:studydocs/features/media/domain/entity/asset_entity.dart';
import 'package:studydocs/features/media/domain/repository/asset_repository.dart';

class AssetRepositoryImpl implements AssetRepository {
  final AssetRemoteDataSource dataSource;

  AssetRepositoryImpl({required this.dataSource});

  @override
  Future<AssetEntity> getAssetById(String id) async {
    final model = await dataSource.getAssetById(id);
    return AssetEntity.fromModel(model);
  }
}
