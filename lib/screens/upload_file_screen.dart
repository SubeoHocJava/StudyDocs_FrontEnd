import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/features/library/widget/library_widgets.dart';

import '../features/model/File.dart';
import '../features/upload_file/data/upload_file_repository.dart';
import '../features/upload_file/logic/upload_file_bloc.dart';
import '../features/upload_file/logic/upload_file_event.dart';
import '../features/upload_file/widget/ListFile.dart';
import '../features/upload_file/widget/SchoolLabel.dart';
import '../features/upload_file/widget/SubjectLabel.dart';

class UploadFileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<MyFile> files = [
      MyFile(
        fileName: "document1.pdf",
        filePath: "/storage/emulated/0/Download/document1.pdf",
      ),
      // MyFile(fileName: "image1.png", filePath: "/storage/emulated/0/Pictures/image1.png"),
      // MyFile(fileName: "music.mp3", filePath: "/storage/emulated/0/Music/music.mp3"),
    ];
    return BlocProvider(
      create:
          (_) =>
              UploadFileBloc(UploadFileRepository())
                ..add(UploadFileLoadDocumentByKeyWord("keyword")),
      child: Scaffold(
        body:
        // BlocBuilder<UploadFileBloc, UploadFileState>(
        //   builder: (context, state) {
        // if (state is UploadFileLoading) {
        //   return const Center(child: CircularProgressIndicator());
        // } else if (state is UploadFileLoaded) {
        //   return
        SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UploadFileButton(onPressed: () {}),
                FileUploadLabel(files: files),
                SchoolLabel(),
                SizedBox(height: 16),
                SubjectLabel(),
              ],
            ),
          ),
        ),
        // ;
        //   } else if (state is UploadFileError) {
        //     return Center(child: Text(state.message));
        //   }
        //   return const Center(child: Text("Chưa có dữ liệu"));
        // },
        // ),
      ),
    );
  }
}
