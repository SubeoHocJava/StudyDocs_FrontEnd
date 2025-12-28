import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/widgets/header.dart';
import 'package:studydocs/features/library/domain/usecase/download_document_usecase.dart';
import 'package:studydocs/features/library/domain/usecase/save_document_usecase.dart' show SaveDocumentUseCase;

import 'package:studydocs/features/library/logic/LibraryEvent.dart';

import '../../../../core/widgets/bottom_nav.dart';
import '../../../upload_file/domain/data/impl/upload_file_repository_implement.dart';
import '../../../upload_file/domain/usecase/upload_file_usecase.dart';
import '../../../upload_file/logic/upload_file_bloc.dart';
import '../../../upload_file/logic/upload_file_event.dart';
import '../../../upload_file/presentation/screen/upload_file_screen.dart';
import '../../domain/repository/impl/lib_repo_impl.dart';
import '../../domain/usecase/like_document_usecase.dart';
import '../../domain/usecase/load_document_usecase.dart';
import '../../domain/usecase/search_document_usecase.dart';
import '../../logic/LibraryState.dart';
import '../../logic/library_bloc.dart';
import '../widget/library_widgets.dart';
import '../widget/recently_upload.dart';
import '../widget/stored_document.dart';
import '../widget/SubjectCategories.dart';
class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LibraryBloc(
        loadDocumentUseCase: LoadDocumentUseCase(LibraryRepositoryImpl()),
        searchDocumentUseCase: SearchDocumentUseCase(LibraryRepositoryImpl()),
        downloadDocumentUseCase: DownloadDocumentUseCase(LibraryRepositoryImpl()),
        saveDocumentUseCase: SaveDocumentUseCase(LibraryRepositoryImpl()),
        likeDocumentUseCase: LikeDocumentUseCase(LibraryRepositoryImpl()),
      )..add(LoadDocumentByKeyWord("keyword")),
      child: Scaffold(
        appBar: Header(),
        body: BlocBuilder<LibraryBloc, LibraryState>(
          builder: (context, state) {
            if (state is LibraryLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is LibraryLoaded) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SearchInput(
                      onSearch: () {
                        context
                            .read<LibraryBloc>()
                            .add(SearchDocument("keyword"));
                      },
                    ),

                    UploadFileButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider(
                              create: (_) => UploadFileBloc(
                                uploadFileUseCase: UploadFileUseCase(
                                  repository: UpLoadFileRepositoryImpl(),
                                ),
                              )..add(
                                UploadFileLoadDocumentByKeyWord("keyword"),
                              ),
                              child: UploadFileScreen(),
                            ),
                          ),
                        );
                      },
                    ),

                    SubjectCategories(state.categories),
                    RecentlyUpload(state.documents),
                    StoredDocument(
                      state.documents,
                      crossAxisCount: 0,
                    ),
                  ],
                ),
              );
            }

            if (state is LibraryError) {
              return Center(child: Text(state.message));
            }

            return const Center(child: Text("Chưa có dữ liệu"));
          },
        ),
        bottomNavigationBar: BottomNav(
          currentIndex: 1,
          onTap: (_) {},
        ),
      ),
    );
  }
}
