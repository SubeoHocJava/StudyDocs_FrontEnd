import 'package:studydocs/sceens/user/document/domain/entity/document.dart';

abstract interface class DocumentRepository {
  Future<Document> getById(String id);
}

class DocumentRepositoryImpl implements DocumentRepository {
  @override
  Future<Document> getById(String id) async {
    return Future.delayed(Duration(seconds: 5));
  }
}
