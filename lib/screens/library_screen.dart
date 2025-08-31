import 'package:flutter/material.dart';

import '../features/library/widget/library_widgets.dart';
import '../features/library/widget/recently_upload/recently_upload.dart';
import '../features/library/widget/stored_document/stored_document.dart';
import '../features/library/widget/subject_categories/SubjectCategories.dart';

class LibraryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
            SubjectCategories(),
            RecentlyUpload(),
            StoredDocument()
          ],
        ),
      ),
    );
  }
}


