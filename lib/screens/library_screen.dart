import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/features/library/data/library_repository.dart';
import 'package:studydocs/features/library/logic/LibraryEvent.dart';

import '../features/library/logic/LibraryState.dart';
import '../features/library/logic/library_bloc.dart';
import '../features/library/widget/library_widgets.dart';
import '../features/library/widget/recently_upload/recently_upload.dart';
import '../features/library/widget/stored_document/stored_document.dart';
import '../features/library/widget/subject_categories/SubjectCategories.dart';

class LibraryScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) =>
              LibraryBloc(LibraryRepository())
                ..add(LoadDocumentByKeyWord("keyword")),
      child: Scaffold(
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
                        print("Search tapped");
                      },
                    ),
                    UploadFileButton(
                      onPressed: () {
                        print("Upload tapped");
                      },
                    ),
                    SubjectCategories(state.categories),
                    RecentlyUpload(state.documents),
                    StoredDocument(state.documents),
                  ],
                ),
              );
            } else if (state is LibraryError) {
              return Center(child: Text(state.message));
            }
            return Center(child: Text("Chưa có dữ liệu"));
          },
        ),
      ),
    );
  }
}
