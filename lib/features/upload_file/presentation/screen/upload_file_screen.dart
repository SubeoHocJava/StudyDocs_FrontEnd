import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/utils/responsive_helper.dart';

import '../../../../core/widgets/bottom_nav.dart';
import '../../../../core/widgets/header.dart';
import '../../../library/presentation/widget/library_widgets.dart';
import '../../domain/data/impl/upload_file_repository_implement.dart';
import '../../domain/usecase/upload_file_usecase.dart';
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
      create: (_) => UploadFileBloc(
        uploadFileUseCase: UploadFileUseCase(
          repository: UpLoadFileRepositoryImpl(),
        ),
      )
        ..add(UploadFileLoadDocumentByKeyWord("keyword"))
        ..add(PickDocument()),
      child: Scaffold(
        body: BlocConsumer<UploadFileBloc, UploadFileState>(
          listener: (context, state) {
            if (state is UploadFileSuccess) {//thông báo success
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Upload thành công!")),
              );
              Navigator.pop(context);
            }
            if (state is UploadFileError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            if (state is UploadFileLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is UploadFileLoaded) {
              return SingleChildScrollView(
                padding: responsive.screenPadding,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UploadFileButton(
                        onPressed: () {
                          context.read<UploadFileBloc>().add(PickDocument());
                        },
                      ),
                      SizedBox(height: responsive.heightPercent(2)),
                      FileUploadLabel(files: state.file),
                      SizedBox(),
                      SchoolLabel(school: state.school),
                      SizedBox(height: responsive.heightPercent(2)),
                      SubjectLabel(subject: state.subject),
                      SizedBox(height: responsive.heightPercent(2)),
                      MoreDetail(),
                    ],
                  ),
                ),
              );
            }

            return const Center(child: Text("Chưa có dữ liệu"));
          },
        ),
      ),
    );
  }
}
