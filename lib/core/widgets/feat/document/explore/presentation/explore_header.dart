import 'package:flutter/material.dart';
import 'package:studydocs/core/constants/app_colors.dart';

class ExploreHeader extends StatelessWidget {
  final String schoolName;
  final String subjectName;
  final int documentCount;
  final int userCount;
  final String searchText;
  final VoidCallback? onSchoolEdit;
  final VoidCallback? onSubjectEdit;
  final ValueChanged<String> onSearchChanged;

  const ExploreHeader({
    super.key,
    required this.schoolName,
    required this.subjectName,
    required this.documentCount,
    required this.userCount,
    required this.searchText,
    required this.onSearchChanged,
    this.onSchoolEdit,
    this.onSubjectEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          schoolName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.profileSchool,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Text(
                subjectName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  height: 1.05,
                  color: AppColors.backgroundNavy,
                ),
              ),
            ),
            if (onSubjectEdit != null) ...[
              const SizedBox(width: 8),
              TextButton(
                onPressed: onSubjectEdit,
                child: const Text(
                  'Chỉnh sửa',
                  style: TextStyle(color: AppColors.primary),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _CountChip(
                  icon: Icons.description_outlined,
                  value: documentCount,
                ),
                const SizedBox(width: 8),
                _CountChip(
                  icon: Icons.group_outlined,
                  value: userCount,
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _ExploreSearchField(
                hint: 'Tìm trong $subjectName',
                value: searchText,
                onChanged: onSearchChanged,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Divider(
          height: 1,
          thickness: 1,
          color: AppColors.divider.withValues(alpha: 0.9),
        ),
      ],
    );
  }
}

class _CountChip extends StatelessWidget {
  final IconData icon;
  final int value;

  const _CountChip({
    required this.icon,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.black),
        const SizedBox(width: 4),
        Text(
          '$value',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
      ],
    );
  }
}

class _ExploreSearchField extends StatefulWidget {
  final String hint;
  final String value;
  final ValueChanged<String> onChanged;

  const _ExploreSearchField({
    required this.hint,
    required this.value,
    required this.onChanged,
  });

  @override
  State<_ExploreSearchField> createState() => _ExploreSearchFieldState();
}

class _ExploreSearchFieldState extends State<_ExploreSearchField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant _ExploreSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && _controller.text != widget.value) {
      _controller.text = widget.value;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: TextField(
        controller: _controller,
        style: const TextStyle(
          fontSize: 13,
          color: AppColors.black,
        ),
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          isDense: true,
          hintText: widget.hint,
          hintStyle: const TextStyle(
            fontSize: 12,
            color: AppColors.docSmallText,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          suffixIcon: const Icon(
            Icons.search,
            color: AppColors.primary,
            size: 20,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
        ),
      ),
    );
  }
}
