import 'package:studydocs/core/widgets/feat/document/information/domain/entity/school_info.dart'
    as information_school_info;
import 'package:studydocs/core/widgets/feat/document/overview/domain/entity/school_info.dart'
    as overview_school_info;

class School {
  final String id;
  final String name;

  const School({required this.id, required this.name});

  overview_school_info.SchoolInfo mapToOverview() {
    return overview_school_info.SchoolInfo(id: id, name: name);
  }

  information_school_info.SchoolInfo mapToInformation() {
    return information_school_info.SchoolInfo(name: name);
  }
}
