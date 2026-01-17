import 'package:studydocs/data/model/api_response.dart';

abstract class AdminRemoteDataSource {
  Future<int> getTotalDocuments();
}
