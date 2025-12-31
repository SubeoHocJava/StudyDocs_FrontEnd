import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/widgets/header.dart';
import 'package:studydocs/features/library/domain/usecase/download_document_usecase.dart';
import 'package:studydocs/features/library/domain/usecase/save_document_usecase.dart' show SaveDocumentUseCase;

import 'package:studydocs/features/library/logic/LibraryEvent.dart';

import 'package:studydocs/core/widgets/bottom_nav.dart';
import 'package:studydocs/features/upload_file/domain/data/impl/upload_file_repository_implement.dart';
import 'package:studydocs/features/upload_file/domain/usecase/upload_file_usecase.dart';
import 'package:studydocs/features/upload_file/logic/upload_file_bloc.dart';
import 'package:studydocs/features/upload_file/logic/upload_file_event.dart';
import 'package:studydocs/features/upload_file/presentation/screen/upload_file_screen.dart';
import 'package:studydocs/features/library/domain/repository/impl/lib_repo_impl.dart';
import 'package:studydocs/features/library/domain/usecase/like_document_usecase.dart';
import 'package:studydocs/features/library/domain/usecase/load_document_usecase.dart';
import 'package:studydocs/features/library/domain/usecase/search_document_usecase.dart';
import 'package:studydocs/features/library/logic/LibraryState.dart';
import 'package:studydocs/features/library/logic/library_bloc.dart';
import 'package:studydocs/features/library/presentation/widget/library_widgets.dart';
import 'package:studydocs/features/library/presentation/widget/recently_upload.dart';
import 'package:studydocs/features/library/presentation/widget/stored_document.dart';
import 'package:studydocs/features/library/presentation/widget/SubjectCategories.dart';
import 'package:studydocs/features/home/presentation/home_screen.dart';
import 'package:studydocs/features/notification/presentation/screen/notification_screen.dart';
import 'package:studydocs/features/subject_library/presentation/screen/subject_library_screen.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
      LibraryBloc(
        loadDocumentUseCase: LoadDocumentUseCase(LibraryRepositoryImpl()),
        searchDocumentUseCase: SearchDocumentUseCase(LibraryRepositoryImpl()),
        downloadDocumentUseCase: DownloadDocumentUseCase(
            LibraryRepositoryImpl()),
        saveDocumentUseCase: SaveDocumentUseCase(LibraryRepositoryImpl()),
        likeDocumentUseCase: LikeDocumentUseCase(LibraryRepositoryImpl()),
      )
        ..add(LoadDocumentByKeyWord("keyword")),
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
                            builder: (_) =>
                                BlocProvider(
                                  create: (_) =>
                                  UploadFileBloc(
                                    uploadFileUseCase: UploadFileUseCase(
                                      repository: UpLoadFileRepositoryImpl(),
                                    ),
                                  )
                                    ..add(
                                      UploadFileLoadDocumentByKeyWord(
                                          "keyword"),
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
      ),
    );
  }
}
