import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/features/library/domain/usecase/download_document_usecase.dart';
import 'package:studydocs/features/library/domain/usecase/save_document_usecase.dart'
    show SaveDocumentUseCase;
import 'package:studydocs/features/library/domain/usecase/get_saved_documents_usecase.dart';

import 'package:studydocs/features/library/logic/LibraryEvent.dart';

import 'package:studydocs/features/upload_file/domain/data/impl/upload_file_repository_implement.dart';
import 'package:studydocs/features/upload_file/domain/usecase/upload_file_usecase.dart';
import 'package:studydocs/features/upload_file/logic/upload_file_bloc.dart';
import 'package:studydocs/features/upload_file/logic/upload_file_event.dart';
import 'package:studydocs/features/upload_file/presentation/screen/upload_file_screen.dart';
import 'package:studydocs/features/library/domain/repository/impl/lib_repo_impl.dart';
import 'package:studydocs/features/subject_library/domain/repository/impl/subject_repository_impl.dart';
import 'package:studydocs/features/subject_library/domain/usecase/get_all_subjects_usecase.dart';
import 'package:studydocs/data/datasource/impl/academic_remote_datasource_impl.dart';
import 'package:studydocs/core/network/dio_client.dart';
import 'package:studydocs/features/library/domain/usecase/like_document_usecase.dart';
import 'package:studydocs/features/library/domain/usecase/load_document_usecase.dart';
import 'package:studydocs/features/library/domain/usecase/search_document_usecase.dart';
import 'package:studydocs/features/library/logic/LibraryState.dart';
import 'package:studydocs/features/library/logic/library_bloc.dart';
import 'package:studydocs/features/library/presentation/widget/library_widgets.dart';
import 'package:studydocs/features/subject_library/domain/entity/subject_entity.dart';
import 'package:studydocs/features/library/presentation/widget/recently_upload.dart';
import 'package:studydocs/features/library/presentation/widget/stored_document.dart';
import 'package:studydocs/features/library/presentation/widget/SubjectCategories.dart';
import 'package:studydocs/core/widgets/document/ListDocument.dart';
import 'package:studydocs/core/widgets/document/model/list_document_ui.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => LibraryBloc(
            loadDocumentUseCase: LoadDocumentUseCase(LibraryRepositoryImpl()),
            searchDocumentUseCase: SearchDocumentUseCase(
              LibraryRepositoryImpl(),
            ),
            downloadDocumentUseCase: DownloadDocumentUseCase(
              LibraryRepositoryImpl(),
            ),
            saveDocumentUseCase: SaveDocumentUseCase(LibraryRepositoryImpl()),
            likeDocumentUseCase: LikeDocumentUseCase(LibraryRepositoryImpl()),
            getSavedDocumentsUseCase: GetSavedDocumentsUseCase(LibraryRepositoryImpl()),
            getAllSubjectsUseCase: GetAllSubjectsUseCase(
              SubjectRepositoryImpl(
                remote: AcademicRemoteDataSourceImpl(dioClient: DioClient()),
              ),
            ),
          )
            ..add(LoadDocumentByKeyWord("keyword"))
            ..add(const LoadSavedDocuments()),
      child: Scaffold(
        body: BlocBuilder<LibraryBloc, LibraryState>(
          builder: (context, state) {
            if (state is LibraryLoading) {
              return const Center(child: CircularProgressIndicator());
            }



            if (state is LibraryLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<LibraryBloc>().add(LoadDocumentByKeyWord("keyword"));
                  context.read<LibraryBloc>().add(const LoadSavedDocuments());
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SearchInput(
                        onSearch: () {
                          context.read<LibraryBloc>().add(
                            SearchDocument("keyword"),
                          );
                        },
                      ),
  
                      UploadFileButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => BlocProvider(
                                    create:
                                        (_) => UploadFileBloc(
                                          uploadFileUseCase: UploadFileUseCase(
                                            repository:
                                                UpLoadFileRepositoryImpl(),
                                          ),
                                        )..add(
                                          UploadFileLoadDocumentByKeyWord(
                                            "keyword",
                                          ),
                                        ),
                                    child: UploadFileScreen(),
                                  ),
                            ),
                          );
                        },
                      ),
  
                      SubjectCategories(state.categories),
                      RecentlyUpload(state.documents),
                      
                      // Saved Documents Section
                      if (state.savedDocuments.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Text(
                            'Tài liệu đã lưu',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ListDocument(
                          state.savedDocuments
                              .map((doc) => doc as DocumentUiList)
                              .toList(),
                          onDownload: (doc) {
                            context.read<LibraryBloc>().add(
                              DownloadDocumentRequested(doc.id!),
                            );
                          },
                          onSave: (doc) {
                            context.read<LibraryBloc>().add(
                              SaveDocumentRequested(doc.id!),
                            );
                          },
                          onLike: (doc) {
                            context.read<LibraryBloc>().add(
                              LikeDocumentRequested(doc.id!),
                            );
                          },
                        ),
                      ],
                      
                      StoredDocument(state.documents, crossAxisCount: 0),
                    ],
                  ),
                ),
              );
            }

            if (state is LibraryError) {
              return Center(child: Text(state.message));
            }

            return const Center(child: Text("Chưa có dữ liệu"));
          },
        ),
      ),
    );
  }
}
