import 'package:studydocs/core/constants/api_constants.dart';
import 'package:studydocs/core/network/dio_client.dart';
import 'package:studydocs/core/exceptions/api_exception.dart';
import 'package:studydocs/data/datasource/admin_remote_datasource.dart';

class AdminRemoteDataSourceImpl implements AdminRemoteDataSource {
  final DioClient dioClient;

  AdminRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<int> getTotalDocuments() async {
    final response = await dioClient.get(DocumentEndpoints.adminStatsDocuments);

    if (response.isSuccess && response.data != null) {
      if (response.data is int) {
        return response.data as int;
      } else if (response.data is String) {
        return int.tryParse(response.data) ?? 0;
      }
    }

    throw ServerException(
      'Failed to fetch total documents stats',
      response.statusCode,
    );
  }
}
