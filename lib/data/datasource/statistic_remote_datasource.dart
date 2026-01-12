import 'dart:math';

/// Mock datasource for statistics feature
/// Returns download statistics for the last 5 days
class StatisticRemoteDataSource {
  /// Mock API: Returns download count for the last 5 days
  /// In production, this would call actual backend API
  Future<List<Map<String, dynamic>>> getDownloadStatistics() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    final now = DateTime.now();
    final random = Random();

    // Generate data for last 5 days
    return List.generate(5, (i) {
      final date = now.subtract(Duration(days: 4 - i));
      return {
        'date': date.toIso8601String(),
        'count': random.nextInt(5) + 1, // Random 1-5 files per day
      };
    });
  }
}
