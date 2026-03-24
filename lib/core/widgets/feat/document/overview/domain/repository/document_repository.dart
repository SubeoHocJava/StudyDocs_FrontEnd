abstract interface class DocumentRepository {
  Future<String> download(String id);
}

class DocumentRepositoryImpl implements DocumentRepository {
  @override
  Future<String> download(String id) async {
    return Future.delayed(Duration(seconds: 5));
  }
}
