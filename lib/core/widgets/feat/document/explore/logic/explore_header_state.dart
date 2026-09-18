import 'package:equatable/equatable.dart';

class ExploreHeaderState extends Equatable {
  final String schoolName;
  final String subjectName;
  final int documentCount;
  final int userCount;
  final String searchText;

  const ExploreHeaderState({
    required this.schoolName,
    required this.subjectName,
    required this.documentCount,
    required this.userCount,
    this.searchText = '',
  });

  ExploreHeaderState copyWith({
    String? schoolName,
    String? subjectName,
    int? documentCount,
    int? userCount,
    String? searchText,
  }) {
    return ExploreHeaderState(
      schoolName: schoolName ?? this.schoolName,
      subjectName: subjectName ?? this.subjectName,
      documentCount: documentCount ?? this.documentCount,
      userCount: userCount ?? this.userCount,
      searchText: searchText ?? this.searchText,
    );
  }

  @override
  List<Object?> get props => [
        schoolName,
        subjectName,
        documentCount,
        userCount,
        searchText,
      ];
}
