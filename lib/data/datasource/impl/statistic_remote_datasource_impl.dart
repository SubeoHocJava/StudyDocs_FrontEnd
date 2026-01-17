import 'package:studydocs/core/constants/api_constants.dart';
import 'package:studydocs/core/network/dio_client.dart';
import '../statistic_remote_datasource.dart';

class StatisticRemoteDataSourceImpl implements StatisticRemoteDataSource {
  final DioClient dioClient;

  StatisticRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<int> getTotalDocuments() async {
    try {
      final response = await dioClient.get(
        ApiConstants.adminStatsTotalDocuments,
      );
      if (response.isSuccess && response.data != null) {
        final data = response.data;
        if (data is int) return data;
        if (data is String) return int.tryParse(data) ?? 0;
      }
      return 0;
    } catch (e) {
      throw Exception('Failed to fetch total documents: $e');
    }
  }

  @override
  Future<int> getSystemStats(String period) async {
    try {
      final response = await dioClient.get(
        ApiConstants.adminStatsSystem,
        queryParameters: {'period': period},
      );
      if (response.isSuccess && response.data != null) {
        final data = response.data;
        if (data is int) return data;
        if (data is String) return int.tryParse(data) ?? 0;
      }
      return 0;
    } catch (e) {
      throw Exception('Failed to fetch system stats for $period: $e');
    }
  }
}
