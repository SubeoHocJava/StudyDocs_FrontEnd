import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/widgets/header.dart';
import 'package:studydocs/features/subject_library/widget/most_liked_docs.dart';

import '../features/library/widget/stored_document/stored_document.dart';
import '../features/subject_library/data/subject_library_repository.dart';
import '../features/subject_library/logic/subject_library_bloc.dart';
import '../features/subject_library/logic/subject_library_event.dart';
import '../features/subject_library/logic/subject_library_state.dart';
import '../features/subject_library/widget/title.dart';
import '../features/subject_library/widget/uploaded_document.dart';

class SubjectLibraryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) =>
              SubjectLibraryBloc(SubjectLibraryRepository())
                ..add(SubjectLibraryLoadDocumentByKeyWord("keyword")),
      child: Scaffold(
        body:
        BlocBuilder<SubjectLibraryBloc, SubjectLibraryState>(
          builder: (context, state) {
            if (state is SubjectLibraryLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is SubjectLibraryLoaded) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TitleSubjectLibrary(state),
                    UploadDocument(state.uploaded_docs),
                    MostLikeDocs(state.the_most_liked_docs),
                    StoredDocument(state.documents),
                  ],
                ),
              );
            } else if (state is SubjectLibraryError) {
              return Center(child: Text(state.message));
            }
            return Center(child: Text("Chưa có dữ liệu"));
          },
        ),
      ),
    );
  }
}
