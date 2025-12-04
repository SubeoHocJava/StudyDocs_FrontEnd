import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/widgets/header.dart';
import 'package:studydocs/features/library/data/library_repository.dart';
import 'package:studydocs/features/library/logic/LibraryEvent.dart';

import '../../../../core/widgets/bottom_nav.dart';
import '../../../upload_file/data/impl/upload_file_repository_implement.dart';
import '../../../upload_file/logic/upload_file_bloc.dart';
import '../../../upload_file/logic/upload_file_event.dart';
import '../../../upload_file/presentation/screen/upload_file_screen.dart';
import '../../logic/LibraryState.dart';
import '../../logic/library_bloc.dart';
import '../widget/library_widgets.dart';
import '../widget/recently_upload/recently_upload.dart';
import '../widget/stored_document/stored_document.dart';
import '../widget/subject_categories/SubjectCategories.dart';


class LibraryScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) =>
              LibraryBloc(LibraryRepository())
                ..add(LoadDocumentByKeyWord("keyword")),
      child: Scaffold(
        appBar: Header(),
        body: BlocBuilder<LibraryBloc, LibraryState>(
          builder: (context, state) {
            if (state is LibraryLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is LibraryLoaded) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SearchInput(
                      onSearch: () {
                        context.read<LibraryBloc>().add(SearchDocument("keyword"));
                        print("Search tapped");
                      },

                    ),
                    UploadFileButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                create: (_) => UploadFileBloc(UpLoadFileRepositoryImpl())
                                  ..add(UploadFileLoadDocumentByKeyWord("keyword")),
                                child: UploadFileScreen(),
                              ),
                            ),
                          );
                        },
                      file: state.filePick?.name

                    ),
                    SubjectCategories(state.categories),
                    RecentlyUpload(state.documents),
                    StoredDocument(state.documents, crossAxisCount: 0,),
                  ],
                ),
              );
            } else if (state is LibraryError) {
              return Center(child: Text(state.message));
            }
            return Center(child: Text("Chưa có dữ liệu"));
          },
        ),
      bottomNavigationBar: BottomNav(currentIndex: 1, onTap: (int value) {  },),
      ),

    );
  }
}
