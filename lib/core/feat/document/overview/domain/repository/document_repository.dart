abstract interface class DocumentRepository {
  Future<void> save(String id);

  Future<void> unsave(String id);

  Future<String> download(String id);
}

class DocumentRepositoryImpl implements DocumentRepository {
  @override
  Future<void> save(String id) async {}

  @override
  Future<void> unsave(String id) async {}

  @override
  Future<String> download(String id) async {
    return Future.delayed(Duration(seconds: 5));
  }
}
