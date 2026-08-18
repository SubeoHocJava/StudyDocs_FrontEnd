import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:studydocs/core/constants/app_colors.dart';
import 'package:studydocs/core/constants/app_icons.dart';
import 'package:studydocs/core/widgets/feat/document/upload/presentation/upload_dropzone_tile.dart';
import 'package:studydocs/core/widgets/feat/document/subject/presentation/document_add_subject_dialog.dart';

import '../logic/document_upload_bloc.dart';
import '../logic/document_upload_event.dart';
import '../logic/document_upload_state.dart';

class DocumentUploadScreen extends StatelessWidget {
  final String? initialFileName;

  const DocumentUploadScreen({super.key, this.initialFileName});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final bloc = DocumentUploadBloc();
        if (initialFileName != null) {
          bloc.add(FileSelected(initialFileName!));
        }
        return bloc;
      },
      child: const _DocumentUploadView(),
    );
  }
}

class _DocumentUploadView extends StatelessWidget {
  const _DocumentUploadView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(32, 16, 32, 32),
        child: BlocBuilder<DocumentUploadBloc, DocumentUploadState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child:
                  // Top Dropzone
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: UploadDropzoneTile(
                        onTap: () async {
                          try {
                            final result =
                                await FilePicker.platform.pickFiles();
                            if (result != null && result.files.isNotEmpty) {
                              if (context.mounted) {
                                context.read<DocumentUploadBloc>().add(
                                  FileSelected(result.files.single.name),
                                );
                              }
                            }
                          } catch (e) {
                            debugPrint('Error picking file: $e');
                          }
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Selected File Widget
                if (state.selectedFileName != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F2F5), // Light grey matching UI
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.description, color: Colors.grey),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            state.selectedFileName!,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            context.read<DocumentUploadBloc>().add(
                              FileRemoved(),
                            );
                          },
                          child: const Icon(Icons.delete, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // School Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          AppAssets.school,
                          width: 20,
                          height: 20,
                          color: Colors.black,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Trường học',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        // Action to edit school
                      },
                      child: const Text(
                        'Chỉnh sửa',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  state.selectedSchoolName ?? 'Chưa chọn trường',
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.primary, // Matching the blue text from UI
                  ),
                ),
                const SizedBox(height: 24),

                // Subject Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          AppAssets.folder,
                          width: 20,
                          height: 20,
                          color: Colors.black,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Môn học',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return DocumentAddSubjectDialog(
                              schoolName:
                                  state.selectedSchoolName ??
                                  'Chưa chọn trường',
                              onAdd: (subjectName) {
                                context.read<DocumentUploadBloc>().add(
                                  SubjectSelected(subjectName),
                                );
                              },
                            );
                          },
                        );
                      },
                      child: const Text(
                        'Chỉnh sửa',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  state.selectedSubjectName ?? 'Chưa chọn môn học',
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.primary, // Matching the blue text from UI
                  ),
                ),

                // Keep Thêm môn học as requested
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return DocumentAddSubjectDialog(
                            schoolName:
                                state.selectedSchoolName ?? 'Chưa chọn trường',
                            onAdd: (subjectName) {
                              context.read<DocumentUploadBloc>().add(
                                SubjectSelected(subjectName),
                              );
                            },
                          );
                        },
                      );
                    },
                    child: const Text(
                      'Thêm môn học',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Tên tài liệu
                const Text(
                  'Tên tài liệu',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Nhập tên ngắn gọn và đúng nội dung',
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Colors.grey.withValues(alpha: 0.3),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Colors.grey.withValues(alpha: 0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.primary),
                    ),
                  ),
                  onChanged: (value) {
                    context.read<DocumentUploadBloc>().add(
                      DocumentNameChanged(value),
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Năm học
                const Text(
                  'Năm học',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Chọn năm học',
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Colors.grey.withValues(alpha: 0.3),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Colors.grey.withValues(alpha: 0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.primary),
                    ),
                  ),
                  onChanged: (value) {
                    context.read<DocumentUploadBloc>().add(
                      SchoolYearChanged(value),
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Mô tả
                const Text(
                  'Mô tả',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextField(
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText:
                        'Mô tả ngắn gọn về tài liệu nhưng đầy đủ thông tin cần thiết',
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Colors.grey.withValues(alpha: 0.3),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Colors.grey.withValues(alpha: 0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.primary),
                    ),
                  ),
                  onChanged: (value) {
                    context.read<DocumentUploadBloc>().add(
                      DescriptionChanged(value),
                    );
                  },
                ),
                const SizedBox(height: 32),

                // Submit Button
                Center(
                  child: SizedBox(
                    width: 160,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<DocumentUploadBloc>().add(
                          UploadSubmitted(),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0000C8),
                        // Deeper blue from screenshot
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        elevation: 0,
                      ),
                      child:
                          state.isSubmitting
                              ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                              : const Text(
                                'Xác nhận',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
