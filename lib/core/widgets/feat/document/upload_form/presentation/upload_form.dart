import 'package:flutter/material.dart';
import 'package:studydocs/core/constants/app_colors.dart';
import 'package:studydocs/core/constants/app_icons.dart';
import 'package:studydocs/core/widgets/feat/document/upload_form/domain/entity/school.dart';
import 'package:studydocs/core/widgets/feat/document/upload_form/domain/entity/subject.dart';

class UploadFormSubmitData {
  final String title;
  final String year;
  final String description;

  const UploadFormSubmitData({
    required this.title,
    required this.year,
    required this.description,
  });
}

/// Form upload UI thuần (không chứa Bloc).
/// Nhận dữ liệu như tên trường, môn, tên file từ bên ngoài.
class UploadForm extends StatefulWidget {
  final String? fileName;
  final School? selectedSchool;
  final Subject? selectedSubject;
  final VoidCallback onPickFile;
  final VoidCallback onChangeSchool;
  final VoidCallback onChangeSubject;
  final VoidCallback? onSubmit;

  const UploadForm({
    super.key,
    required this.fileName,
    required this.selectedSchool,
    required this.selectedSubject,
    required this.onPickFile,
    required this.onChangeSchool,
    required this.onChangeSubject,
    this.onSubmit,
  });

  @override
  State<UploadForm> createState() => _UploadFormState();
}

class _UploadFormState extends State<UploadForm> {
  final _titleController = TextEditingController();
  final _yearController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _yearController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        _UploadFileTile(
          fileName: widget.fileName,
          onTap: widget.onPickFile,
        ),
        const SizedBox(height: 16),
        _SelectorSection(
          iconAsset: AppAssets.school,
          label: 'Trường học',
          valueText: widget.selectedSchool?.name ?? 'Chọn trường học',
          onEdit: widget.onChangeSchool,
        ),
        const SizedBox(height: 16),
        _SelectorSection(
          iconAsset: AppAssets.folder,
          label: 'Môn học',
          valueText: widget.selectedSubject?.name ?? 'Chọn môn học',
          onEdit: widget.onChangeSubject,
        ),
        const SizedBox(height: 24),
        _LabeledTextField(
          label: 'Tên tài liệu',
          hint: 'Nhập tên ngắn gọn và đúng nội dung',
          controller: _titleController,
        ),
        const SizedBox(height: 16),
        _LabeledTextField(
          label: 'Năm học',
          hint: 'Chọn năm học',
          controller: _yearController,
        ),
        const SizedBox(height: 16),
        _LabeledTextField(
          label: 'Mô tả',
          hint: 'Mô tả ngắn gọn về tài liệu nhưng đầy đủ thông tin cần thiết',
          controller: _descriptionController,
          maxLines: 3,
        ),
        const SizedBox(height: 24),
        Align(
          alignment: Alignment.center,
          child: SizedBox(
            width: 220,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                widget.onSubmit?.call();
              },
              child: const Text(
                'Xác nhận',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _UploadFileTile extends StatelessWidget {
  final String? fileName;
  final VoidCallback onTap;

  const _UploadFileTile({
    required this.fileName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Image.asset(
              AppAssets.upload,
              width: 20,
              height: 20,
              color: AppColors.black,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                fileName ?? 'Chọn file tài liệu',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textPrimaryLight,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectorSection extends StatelessWidget {
  final String iconAsset;
  final String label;
  final String valueText;
  final VoidCallback onEdit;

  const _SelectorSection({
    required this.iconAsset,
    required this.label,
    required this.valueText,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset(
              iconAsset,
              width: 20,
              height: 20,
              color: AppColors.black,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: AppColors.black,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: onEdit,
              child: const Text(
                'Chỉnh sửa',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          valueText,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.profileSchool,
          ),
        ),
      ],
    );
  }
}

class _LabeledTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final int maxLines;

  const _LabeledTextField({
    required this.label,
    required this.hint,
    required this.controller,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondaryLight,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }
}

