abstract interface class ReviewRepository {
  //Chỉ xử lý cho text cho hiện tại
  Future<void> comment(String documentId, String content);
}

class ReviewRepositoryImpl implements ReviewRepository {
  @override
  Future<void> comment(String documentId, String content) async {}
}
