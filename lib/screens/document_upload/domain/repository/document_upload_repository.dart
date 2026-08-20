import 'package:dio/dio.dart';

abstract interface class DocumentUploadRepository {
  Future<dynamic> uploadDocument(FormData data);
}
