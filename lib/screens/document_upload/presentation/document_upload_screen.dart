import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:studydocs/core/constants/app_colors.dart';
import 'package:studydocs/core/constants/app_icons.dart';
import 'package:studydocs/core/widgets/feat/document/upload/presentation/upload_dropzone_tile.dart';
import 'package:studydocs/core/widgets/feat/document/subject/presentation/document_add_subject_dialog.dart';
import 'package:studydocs/core/widgets/feat/document/upload/presentation/document_select_option_dialog.dart';

import 'package:go_router/go_router.dart';

import '../logic/document_upload_bloc.dart';
import '../logic/document_upload_event.dart';
import '../logic/document_upload_state.dart';

class DocumentUploadScreen extends StatelessWidget {
  final PlatformFile? initialFile;

  const DocumentUploadScreen({super.key, this.initialFile});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final bloc = DocumentUploadBloc();
        bloc.add(LoadUniversities());
        if (initialFile != null) {
          bloc.add(FileSelected(initialFile!));
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
    final bloc = context.read<DocumentUploadBloc>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(32, 16, 32, 32),
        child: BlocConsumer<DocumentUploadBloc, DocumentUploadState>(
          listenWhen: (previous, current) => 
              previous.isSuccess != current.isSuccess || previous.errorMessage != current.errorMessage,
          listener: (context, state) {
            if (state.isSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Tải lên thành công!'),
                  backgroundColor: Colors.green,
                ),
              );
              context.go('/library');
            } else if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
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
                                  await FilePicker.platform.pickFiles(withData: true);
                              if (result != null && result.files.isNotEmpty) {
                                if (context.mounted) {
                                  context.read<DocumentUploadBloc>().add(
                                    FileSelected(result.files.single),
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
                _buildSelectionRow(
                  context: context,
                  title: 'Trường học',
                  icon: AppAssets.school,
                  selectedValue: state.selectedSchoolName,
                  hintValue: 'Chưa chọn trường',
                  isLoading: state.isLoadingUniversities,
                  onEditTap: () {
                    showDialog(
                      context: context,
                      builder: (dialogContext) {
                        return DocumentSelectOptionDialog(
                          title: 'Chọn trường học',
                          hintText: 'Tìm trường học...',
                          initialValueName: state.selectedSchoolName,
                          options: state.universities,
                          onSelected: (id, name) => context.read<DocumentUploadBloc>().add(SchoolSelected(id, name)),
                        );
                      },
                    );
                  },
                ),
                
                // Faculty Section
                _buildSelectionRow(
                  context: context,
                  title: 'Khoa',
                  icon: AppAssets.folder, // Use appropriate icon if available
                  selectedValue: state.selectedFacultyName,
                  hintValue: 'Chưa chọn khoa',
                  isLoading: state.isLoadingFaculties,
                  onEditTap: state.universityId == null
                      ? () => _showWarning(context, 'Vui lòng chọn trường học trước')
                      : () {
                          showDialog(
                            context: context,
                            builder: (dialogContext) {
                              return DocumentSelectOptionDialog(
                                title: 'Chọn Khoa',
                                hintText: 'Tìm khoa...',
                                initialValueName: state.selectedFacultyName,
                                options: state.faculties,
                                onSelected: (id, name) => context.read<DocumentUploadBloc>().add(FacultySelected(id, name)),
                              );
                            },
                          );
                        },
                ),
                
                // Department Section
                _buildSelectionRow(
                  context: context,
                  title: 'Bộ môn',
                  icon: AppAssets.folder,
                  selectedValue: state.selectedDepartmentName,
                  hintValue: 'Chưa chọn bộ môn',
                  isLoading: state.isLoadingDepartments,
                  onEditTap: state.facultyId == null
                      ? () => _showWarning(context, 'Vui lòng chọn khoa trước')
                      : () {
                          showDialog(
                            context: context,
                            builder: (dialogContext) {
                              return DocumentSelectOptionDialog(
                                title: 'Chọn Bộ môn',
                                hintText: 'Tìm bộ môn...',
                                initialValueName: state.selectedDepartmentName,
                                options: state.departments,
                                onSelected: (id, name) => context.read<DocumentUploadBloc>().add(DepartmentSelected(id, name)),
                              );
                            },
                          );
                        },
                ),

                // Subject Section
                _buildSelectionRow(
                  context: context,
                  title: 'Môn học',
                  icon: AppAssets.folder,
                  selectedValue: state.selectedSubjectName,
                  hintValue: 'Chưa chọn môn học',
                  isLoading: state.isLoadingSubjects,
                  onEditTap: state.departmentId == null
                      ? () => _showWarning(context, 'Vui lòng chọn bộ môn trước')
                      : () {
                          showDialog(
                            context: context,
                            builder: (dialogContext) {
                              return DocumentSelectOptionDialog(
                                title: 'Chọn môn học',
                                hintText: 'Tìm môn học...',
                                initialValueName: state.selectedSubjectName,
                                options: state.subjects,
                                onSelected: (id, name) => context.read<DocumentUploadBloc>().add(SubjectSelected(id, name)),
                              );
                            },
                          );
                        },
                ),

                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext dialogContext) {
                          return DocumentAddSubjectDialog(
                            schoolName:
                                state.selectedSchoolName ?? 'Chưa chọn trường',
                            onAdd: (subjectName) {
                              bloc.add(SubjectSelected(-1, subjectName));
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
                        if (state.selectedFile == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Vui lòng chọn file tài liệu!'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        // Validate Document Name
                        final docName = state.documentName ?? state.selectedFileName ?? '';
                        if (docName.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Vui lòng nhập tên tài liệu!'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        // Validate School Year
                        final year = state.schoolYear ?? '';
                        final yearRegex = RegExp(r'^\d+\s*-\s*\d+$');
                        if (!yearRegex.hasMatch(year.trim())) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Năm học phải có định dạng số - số (VD: 2023 - 2024)'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        bloc.add(UploadSubmitted());
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

  void _showWarning(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.orange,
      ),
    );
  }

  Widget _buildSelectionRow({
    required BuildContext context,
    required String title,
    required String icon,
    required String? selectedValue,
    required String hintValue,
    required VoidCallback onEditTap,
    bool isLoading = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  icon,
                  width: 20,
                  height: 20,
                  color: Colors.black,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (isLoading)
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
              ],
            ),
            GestureDetector(
              onTap: onEditTap,
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
          selectedValue ?? hintValue,
          style: const TextStyle(
            fontSize: 15,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
