import 'package:studydocs/features/explore/domain/entity/school_entity.dart';
import 'package:studydocs/features/explore/domain/repository/explore_repository.dart';

class SearchSchoolsUseCase {
  final ExploreRepository repository;

  SearchSchoolsUseCase({required this.repository});

  Future<List<SchoolEntity>> call(String query) {
    return repository.searchSchools(query);
  }
}

class GetCurrentSchoolUseCase {
  final ExploreRepository repository;

  GetCurrentSchoolUseCase({required this.repository});

  Future<SchoolEntity?> call() {
    return repository.getCurrentUserSchool();
  }
}


