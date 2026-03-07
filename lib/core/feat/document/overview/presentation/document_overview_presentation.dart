import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/feat/document/overview/logic/document_overview_bloc.dart';
import 'package:studydocs/core/feat/document/overview/logic/document_overview_event.dart';
import 'package:studydocs/core/feat/document/overview/logic/document_overview_state.dart';
import 'package:studydocs/core/constants/app_colors.dart';
import 'package:studydocs/core/constants/app_icons.dart';

class DocumentOverviewPresentation extends StatelessWidget {
  const DocumentOverviewPresentation({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DocumentOverviewBloc, DocumentOverviewState>(
      builder: (context, state) {
        if (state is DocumentOverviewLoaded) {
          return Card(
            color: AppColors.white,
            surfaceTintColor: AppColors.white,
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          state.documentOverview.title,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.navy,
                          ),
                        ),
                      ),
                      Image.asset(
                        AppAssets.chevronDown,
                        width: 30,
                        height: 30,
                        color: AppColors.black,
                      ),
                    ],
                  ),

                  SizedBox(height: 12),
                  Divider(color: AppColors.divider),
                  SizedBox(height: 12),

                  // Course
                  Row(
                    children: [
                      Image.asset(
                        AppAssets.folder,
                        width: 20,
                        height: 20,
                        color: AppColors.black,
                      ),
                      SizedBox(width: 8),
                      InkWell(
                        onTap: () {
                          context.read<DocumentOverviewBloc>().add(
                            SchoolClicked(
                              schoolId: state.documentOverview.courseInfo.id,
                            ),
                          );
                        },
                        child: Text(
                          state.documentOverview.courseInfo.name,
                          style: TextStyle(color: AppColors.secondaryBlue),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  // School
                  Row(
                    children: [
                      Image.asset(
                        AppAssets.school,
                        width: 20,
                        height: 20,
                        color: AppColors.black,
                      ),
                      SizedBox(width: 8),
                      InkWell(
                        onTap: () {
                          context.read<DocumentOverviewBloc>().add(
                            SchoolClicked(
                              schoolId: state.documentOverview.schoolInfo.id,
                            ),
                          );
                        },
                        child: Text(
                          state.documentOverview.schoolInfo.name,
                          style: TextStyle(color: AppColors.secondaryBlue),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Download
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        onPressed: () {
                          context.read<DocumentOverviewBloc>().add(
                            DocumentDownloadRequested(
                              id: state.documentOverview.id,
                            ),
                          );
                        },
                        icon: Image.asset(
                          AppAssets.download,
                          width: 20,
                          height: 20,
                          color: AppColors.white,
                        ),
                        label: Text(
                          "Tải về",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      //Bookmark
                      IconButton(
                        onPressed: () {
                          if (state.documentOverview.isSaved) {
                            context.read<DocumentOverviewBloc>().add(
                              DocumentUnSave(id: state.documentOverview.id),
                            );
                          } else {
                            context.read<DocumentOverviewBloc>().add(
                              DocumentSave(id: state.documentOverview.id),
                            );
                          }
                        },
                        icon: Image.asset(
                          state.documentOverview.isSaved
                              ? AppAssets.saved
                              : AppAssets.unsaved,
                          width: 24,
                          height: 24,
                          color:
                              state.documentOverview.isSaved
                                  ? AppColors.warning
                                  : AppColors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
        return Text("empty");
      },
    );
  }
}
