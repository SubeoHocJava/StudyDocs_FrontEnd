/// Entity đại diện cho 1 trường (trong phần Khám phá).
class SchoolEntity {
  final String id;
  final String name;
  final String? shortName;

  const SchoolEntity({
    required this.id,
    required this.name,
    this.shortName,
  });
}


