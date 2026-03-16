// Domain docs_card — cấu trúc tách rõ như feature comment:
//
// - repository/document_repository.dart  → interface like, bookmark, download
// - usecase/like_document_usecase.dart    → LikeDocumentUseCase (+ Impl)
// - usecase/bookmark_document_usecase.dart → BookmarkDocumentUseCase (+ Impl)
// - usecase/download_document_usecase.dart → DownloadDocumentUseCase (+ Impl)
//
// Bloc nhận UseCase, không gọi Repository trực tiếp. Implement Repository ở Data (DocumentDatasource).
