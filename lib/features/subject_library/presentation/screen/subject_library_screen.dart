import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:studydocs/core/utils/responsive_helper.dart';
import 'package:studydocs/core/widgets/header.dart';
import 'package:studydocs/core/widgets/bottom_nav.dart';
import 'package:studydocs/core/router/app_router.dart';
import 'package:studydocs/features/library/domain/model/document_library.dart';
import 'package:studydocs/features/library/presentation/widget/SubjectCategories.dart';
import 'package:studydocs/features/subject_library/logic/subject_library_bloc.dart';
import 'package:studydocs/features/subject_library/logic/subject_library_state.dart';
import 'package:studydocs/features/subject_library/presentation/widget/most_liked_docs.dart';
import 'package:studydocs/features/subject_library/presentation/widget/title.dart';
import 'package:studydocs/features/subject_library/presentation/widget/uploaded_document.dart';

import '../../../library/presentation/widget/stored_document.dart';

class SubjectLibraryScreen extends StatelessWidget {
  final String schoolName;

  const SubjectLibraryScreen({
    super.key,
    required this.schoolName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(isDefault: true),
      body: BlocBuilder<SubjectLibraryBloc, SubjectLibraryState>(
        builder: (context, state) {
          if (state is SubjectLibraryLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state is SubjectLibraryLoaded) {
            final responsive = context.responsive;
            return SingleChildScrollView(
              padding: responsive.screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tiêu đề với tên trường và search bar lớn
                  TitleSubjectLibrary(
                    state,
                    fontSize: responsive.fontSize(22),
                    schoolName: schoolName,
                  ),
                  SizedBox(height: responsive.heightPercent(2)),

                  // Section "Môn học"
                  if (state.subjects.isNotEmpty) ...[
                    SubjectCategories(
                      state.subjects.map((s) => s.name).toList(),
                      onSubjectTap: (subjectName) {
                        final encodedSchoolName = Uri.encodeComponent(schoolName);
                        final encodedSubjectName = Uri.encodeComponent(subjectName);
                        context.push('/school/$encodedSchoolName/subject/$encodedSubjectName');
                      },
                    ),
                    SizedBox(height: responsive.heightPercent(3)),
                  ],

                  // Danh sách tài liệu của trường
                  if (state.documents.isNotEmpty) ...[
                    const Padding(
                      padding: EdgeInsets.only(bottom: 12.0),
                      child: Text(
                        'Tài liệu',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    StoredDocument(state.documents.cast<DocumentLibraryUI>()),
                  ],


                  // Tài liệu đã lưu (nếu có)
                  if (state.documents.isNotEmpty)
                    StoredDocument(state.documents.cast<DocumentLibraryUI>()),
                ],
              ),
            );
          }

          if (state is SubjectLibraryError) {
            return Center(child: Text(state.message));
          }

          return const Center(child: Text("Chưa có dữ liệu trang subject"));
        },
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: -1, // No tab active
        onTap: (index) {
          // Navigate to the nested tab root.
          switch (index) {
            case 0:
              context.go(AppRoutes.home);
              break;
            case 1:
              context.go(AppRoutes.library);
              break;
            case 2:
              context.go(AppRoutes.explore);
              break;
            case 3:
              context.go(AppRoutes.notifications);
              break;
            default:
              context.go(AppRoutes.home);
          }
        },
      ),
    );
  }
}
