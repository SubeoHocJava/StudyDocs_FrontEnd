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
import 'package:studydocs/features/subject_library/presentation/widget/title.dart';

import '../../../library/presentation/widget/stored_document.dart';
import 'package:studydocs/features/subject_library/logic/subject_library_event.dart';

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
            return RefreshIndicator(
              onRefresh: () async {
                // Reload documents for this school
                context.read<SubjectLibraryBloc>().add(
                  SubjectLibraryLoadBySchool(
                    state.schoolId ?? '',
                    state.schoolName,
                  ),
                );
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
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
                        state.subjects,
                        onSubjectTap: (index) {
                          final subject = state.subjects[index];
                          final schoolId = state.schoolId ?? '';
                          final schoolName = state.schoolName;
                          
                          final encodedSchoolName = Uri.encodeComponent(schoolName);
                          final encodedSubjectName = Uri.encodeComponent(subject.name);
                          
                          context.push(
                            '/school/$schoolId/subject/${subject.id}?schoolName=$encodedSchoolName&subjectName=$encodedSubjectName'
                          );
                        },
                      ),
                      SizedBox(height: responsive.heightPercent(3)),
                    ],

                    // Danh sách tài liệu của trường
                    if (state.documents.isNotEmpty) ...[
                      StoredDocument(
                        state.documents.cast<DocumentLibraryUI>(),
                        onDownload: (doc) {
                          context.read<SubjectLibraryBloc>().add(
                            SubjectLibraryDownloadDocument(doc.id),
                          );
                        },
                        onSave: (doc) {
                          context.read<SubjectLibraryBloc>().add(
                            SubjectLibraryBookmarkDocument(doc.id),
                          );
                        },
                        onLike: (doc) {
                          context.read<SubjectLibraryBloc>().add(
                            SubjectLibraryLikeDocument(doc.id),
                          );
                        },
                        onComment: (doc) {
                          context.read<SubjectLibraryBloc>().add(
                            SubjectLibraryOpenComment(doc.id),
                          );
                        },
                        onTap: (doc) {
                          context.push('/document/${doc.id}');
                        },
                      ),
                    ],
                  ],
                ),
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
