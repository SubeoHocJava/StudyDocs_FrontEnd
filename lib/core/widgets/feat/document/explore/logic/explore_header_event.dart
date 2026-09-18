import 'package:equatable/equatable.dart';

abstract class ExploreHeaderEvent extends Equatable {
  const ExploreHeaderEvent();

  @override
  List<Object?> get props => [];
}

class ExploreHeaderInitialized extends ExploreHeaderEvent {
  final String schoolName;
  final String subjectName;
  final int documentCount;
  final int userCount;
  final String searchText;

  const ExploreHeaderInitialized({
    required this.schoolName,
    required this.subjectName,
    required this.documentCount,
    required this.userCount,
    this.searchText = '',
  });

  @override
  List<Object?> get props => [
        schoolName,
        subjectName,
        documentCount,
        userCount,
        searchText,
      ];
}

class ExploreSchoolNameChanged extends ExploreHeaderEvent {
  final String value;

  const ExploreSchoolNameChanged(this.value);

  @override
  List<Object?> get props => [value];
}

class ExploreSubjectNameChanged extends ExploreHeaderEvent {
  final String value;

  const ExploreSubjectNameChanged(this.value);

  @override
  List<Object?> get props => [value];
}

class ExploreCountsChanged extends ExploreHeaderEvent {
  final int documentCount;
  final int userCount;

  const ExploreCountsChanged({
    required this.documentCount,
    required this.userCount,
  });

  @override
  List<Object?> get props => [documentCount, userCount];
}

class ExploreSearchChanged extends ExploreHeaderEvent {
  final String value;

  const ExploreSearchChanged(this.value);

  @override
  List<Object?> get props => [value];
}
