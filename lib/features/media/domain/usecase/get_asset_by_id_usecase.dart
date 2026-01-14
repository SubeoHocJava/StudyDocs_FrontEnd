import 'package:studydocs/features/media/domain/entity/asset_entity.dart';
import 'package:studydocs/features/media/domain/repository/asset_repository.dart';

class GetAssetByIdUseCase {
  final AssetRepository repository;

  GetAssetByIdUseCase({required this.repository});

  Future<AssetEntity> call(String id) {
    return repository.getAssetById(id);
  }
}
