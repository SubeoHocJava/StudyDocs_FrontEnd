import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/utils/responsive_helper.dart';
import 'package:studydocs/features/upload_file/data/impl/upload_file_repository_implement.dart';

import '../../../../core/widgets/bottom_nav.dart';
import '../../../../core/widgets/header.dart';
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
    final responsive = context.responsive;
    return BlocProvider(
      create:
          (_) =>
              UploadFileBloc(UpLoadFileRepositoryImpl())
                ..add(UploadFileLoadDocumentByKeyWord("keyword")) ..add(PickDocument()),
      child: Scaffold(
        appBar: Header(),
        body: BlocBuilder<UploadFileBloc, UploadFileState>(
          builder: (context, state) {
            if (state is UploadFileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UploadFileLoaded) {
              return SingleChildScrollView(
                padding: responsive.screenPadding,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UploadFileButton(
                        onPressed: () {
                          context.read<UploadFileBloc>().add(PickDocument());
                          print("Upload tapped");
                        },

                      ),
                      SizedBox(height: responsive.heightPercent(2)),
                      FileUploadLabel(files:state.file),
                      SizedBox(),
                      SchoolLabel(school:state.school),
                      SizedBox(height: responsive.heightPercent(2)),
                      SubjectLabel(subject:state.subject),
                      SizedBox(height: responsive.heightPercent(2)),
                      MoreDetail(),
                    ],
                  ),
                ),
              );
            } else if (state is UploadFileError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text("Chưa có dữ liệu"));
          },
        ),
        bottomNavigationBar: BottomNav(currentIndex: 0, onTap: (int value) {}),
      ),
    );
  }
}
