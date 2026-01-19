import '../entity/subject_entity.dart';
import '../repository/subject_repository.dart';

class GetAllSubjectsUseCase {
  final SubjectRepository repository;

  GetAllSubjectsUseCase(this.repository);

  Future<List<SubjectEntity>> call() {
    return repository.getAllSubjects();
  }
}
