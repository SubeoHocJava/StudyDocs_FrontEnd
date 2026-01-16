
import 'package:studydocs/core/network/dio_client.dart';
import '../statistic_remote_datasource.dart';

class StatisticRemoteDataSourceImpl implements StatisticRemoteDataSource {
  final DioClient dioClient;

  StatisticRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<int> getTotalDocuments() async {
    try {
      final response = await dioClient.get(
        '/api/v1/documents/admin/stats/documents/total',
      );
      if (response.isSuccess && response.data != null) {
        return response.data as int;
      }
      return 0; // Default fallback
    } catch (e) {
      // Log or rethrow depending on strategy. Rethrowing for Repo to handle.
      throw Exception('Failed to fetch total documents: $e');
    }
  }

  @override
  Future<int> getSystemStats(String period) async {
    try {
      final response = await dioClient.get(
        '/api/v1/documents/admin/stats/system',
        queryParameters: {'period': period},
      );
      if (response.isSuccess && response.data != null) {
        return response.data as int;
      }
      return 0; // Default fallback
    } catch (e) {
      throw Exception('Failed to fetch system stats for $period: $e');
    }
  }
}
