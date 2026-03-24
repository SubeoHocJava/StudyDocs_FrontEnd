abstract interface class LibraryRepository {
  Future<void> save(String id);

  Future<void> unsave(String id);
}

class LibraryRepositoryImpl implements LibraryRepository {
  @override
  Future<void> save(String id) async {
    // Mock implementation
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<void> unsave(String id) async {
    // Mock implementation
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
