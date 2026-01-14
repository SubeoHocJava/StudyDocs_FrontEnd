import 'package:studydocs/data/datasource/academic_remote_datasource.dart';
import 'package:studydocs/features/explore/domain/entity/school_entity.dart';
import 'package:studydocs/features/explore/domain/repository/explore_repository.dart';

class ExploreRepositoryImpl implements ExploreRepository {
  final AcademicRemoteDataSource remote;

  ExploreRepositoryImpl({required this.remote});

  @override
  Future<SchoolEntity?> getCurrentUserSchool() {
    return remote.getCurrentUserSchool();
  }

  @override
  Future<List<SchoolEntity>> searchSchools(String query) {
    return remote.searchSchools(query);
  }
}


