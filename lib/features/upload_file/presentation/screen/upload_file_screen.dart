import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../../library/data/model/File.dart';
import '../../../library/presentation/widget/library_widgets.dart';

import '../../data/upload_file_repository.dart';
import '../../logic/upload_file_bloc.dart';
import '../../logic/upload_file_event.dart';
import '../../logic/upload_file_state.dart';
import '../widget/ListFile.dart';
import '../widget/MoreDetail.dart';
import '../widget/SchoolLabel.dart';
import '../widget/SubjectLabel.dart';


class UploadFileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<MyFile> files = [
      MyFile(
        fileName: "document1.pdf",
        filePath: "/storage/emulated/0/Download/document1.pdf",
      ),
    ];
    return BlocProvider(
      create:
          (_) =>
      UploadFileBloc(UploadFileRepository())
        ..add(UploadFileLoadDocumentByKeyWord("keyword")),
      child: Scaffold(
        body:
        BlocBuilder<UploadFileBloc, UploadFileState>(
          builder: (context, state) {
            if (state is UploadFileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UploadFileLoaded) {
              return
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
                        SizedBox(height: 16),
                        MoreDetail(),
                      ],
                    ),
                  ),
                )
            ;
            } else if (state is UploadFileError) {
            return Center(child: Text(state.message));
            }
            return const Center(child: Text("Chưa có dữ liệu"
            )
            );
          },
        ),
      ),
    );
  }
}


