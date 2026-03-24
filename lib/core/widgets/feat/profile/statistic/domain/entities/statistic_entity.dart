import 'package:equatable/equatable.dart';

class StatisticEntity extends Equatable {
  final int totalDocuments;
  final int totalLikes;
  final int totalComments;

  const StatisticEntity({
    required this.totalDocuments,
    required this.totalLikes,
    required this.totalComments,
  });

  @override
  List<Object?> get props => [
        totalDocuments,
        totalLikes,
        totalComments,
      ];
}
