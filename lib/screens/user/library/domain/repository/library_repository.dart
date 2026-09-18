import 'package:studydocs/screens/user/library/domain/entity/library_page_data.dart';
import 'package:studydocs/screens/user/library/domain/entity/library_subject_page_data.dart';

abstract interface class LibraryRepository {
  Future<LibraryPageData> getLibraryPage();

  Future<LibrarySubjectPageData> getLibrarySubjectPage(String subjectId);
}
