
import 'package:equatable/equatable.dart';

class StatisticEntity extends Equatable {
  final int totalDocuments;
  final int dayCount;
  final int monthCount;
  final int yearCount;
  final int totalLikes;
  final int totalComments;

  const StatisticEntity({
    required this.totalDocuments,
    required this.dayCount,
    required this.monthCount,
    required this.yearCount,
    required this.totalLikes,
    required this.totalComments,
  });

  factory StatisticEntity.initial() {
    return const StatisticEntity(
      totalDocuments: 0,
      dayCount: 0,
      monthCount: 0,
      yearCount: 0,
      totalLikes: 0,
      totalComments: 0,
    );
  }

  @override
  List<Object?> get props => [
        totalDocuments,
        dayCount,
        monthCount,
        yearCount,
        totalLikes,
        totalComments,
      ];
}
