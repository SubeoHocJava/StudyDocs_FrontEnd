import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/utils/responsive_helper.dart';
import 'package:studydocs/core/widgets/bottom_nav.dart';
import 'package:studydocs/core/widgets/header.dart';
import 'package:studydocs/features/subject_library/domain/usecase/DocsUseCase.dart';

import '../../../library/presentation/widget/stored_document/stored_document.dart';
import '../../domain/data/impl/SubjectLibraryRepositoryImpl.dart';
import '../../logic/subject_library_bloc.dart';
import '../../logic/subject_library_event.dart';
import '../../logic/subject_library_state.dart';
import '../widget/most_liked_docs.dart';
import '../widget/title.dart';
import '../widget/uploaded_document.dart';

class SubjectLibraryScreen extends StatelessWidget {
  final repository = SubjectLibraryRepositoryImpl();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => SubjectLibraryBloc(
            searchDocumentsUseCase: SearchDocumentsUseCase(
              repository: repository,
            ),
            likeDocumentUseCase: LikeDocumentUseCase(repository: repository),
            getCommentsUseCase: GetCommentsUseCase(repository: repository),
            downloadDocumentUseCase: DownloadDocumentUseCase(repository: repository),
            bookmarkDocumentUseCase: BookmarkDocumentUseCase(repository: repository),
          )..add(SubjectLibraryLoadDocumentByKeyWord("keyword")),
      child: Scaffold(
        appBar: Header(),
        body: BlocBuilder<SubjectLibraryBloc, SubjectLibraryState>(
          builder: (context, state) {
            print('Current SubjectLibraryState: $state');

            if (state is SubjectLibraryLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is SubjectLibraryLoaded) {
              final responsive = context.responsive;
              return SingleChildScrollView(
                padding: responsive.screenPadding,
                // responsive padding toàn trang
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tiêu đề responsive
                    TitleSubjectLibrary(
                      state,
                      fontSize: responsive.fontSize(22),
                    ),
                    SizedBox(height: responsive.heightPercent(2)),

                    // Tài liệu đã upload
                    UploadDocument(state.uploaded_docs),
                    SizedBox(height: responsive.heightPercent(3)),

                    // Tài liệu được thích nhiều nhất
                    MostLikeDocs(state.the_most_liked_docs),
                    SizedBox(height: responsive.heightPercent(3)),
                    // Tài liệu đã lưu
                    StoredDocument(state.documents),
                  ],
                ),
              );
            }

            if (state is SubjectLibraryError) {
              return Center(child: Text(state.message));
            }

            return Center(child: Text("Chưa có dữ liệu trang subject"));
          },
        ),
        bottomNavigationBar: BottomNav(currentIndex: 2, onTap: (int value) {}),
      ),
    );
  }
}
