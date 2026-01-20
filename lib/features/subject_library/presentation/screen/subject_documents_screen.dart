import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:studydocs/core/utils/responsive_helper.dart';
import 'package:studydocs/core/widgets/header.dart';
import 'package:studydocs/core/widgets/bottom_nav.dart';
import 'package:studydocs/core/router/app_router.dart';
import 'package:studydocs/features/library/domain/model/document_library.dart';
import 'package:studydocs/features/subject_library/logic/subject_library_bloc.dart';
import 'package:studydocs/features/subject_library/logic/subject_library_state.dart';
import 'package:studydocs/features/subject_library/logic/subject_library_event.dart';
import '../../../library/presentation/widget/stored_document.dart';

class SubjectDocumentsScreen extends StatelessWidget {
  final String schoolName;
  final String subjectName;
  const SubjectDocumentsScreen({
    super.key,
    required this.schoolName,
    required this.subjectName,
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
                // Reload documents for this subject
                context.read<SubjectLibraryBloc>().add(
                  SubjectLibraryLoadBySubject(
                    schoolId: state.schoolId ?? '',
                    subjectId: state.subjectId ?? '',
                    subjectName: subjectName,
                    schoolName: schoolName,
                  ),
                );
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: responsive.screenPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tiêu đề: Tên trường > Tên môn
                    Padding(
                      padding: EdgeInsets.only(bottom: responsive.heightPercent(2)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            schoolName,
                            style: TextStyle(
                              fontSize: responsive.fontSize(18),
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: responsive.heightPercent(1)),
                          Text(
                            subjectName,
                            style: TextStyle(
                              fontSize: responsive.fontSize(24),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Danh sách tài liệu
                    if (state.documents.isNotEmpty)
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
                    
                    if (state.documents.isEmpty)
                      Center(
                        child: Padding(
                          padding: EdgeInsets.all(responsive.heightPercent(5)),
                          child: Text(
                            'Chưa có tài liệu cho môn học này',
                            style: TextStyle(
                              fontSize: responsive.fontSize(16),
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }

          if (state is SubjectLibraryError) {
            return Center(child: Text(state.message));
          }

          return const Center(child: Text("Chưa có dữ liệu"));
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
