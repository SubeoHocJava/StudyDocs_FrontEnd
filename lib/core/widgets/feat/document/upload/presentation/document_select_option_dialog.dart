import 'package:flutter/material.dart';
import 'package:studydocs/core/constants/app_colors.dart';

class DocumentSelectOptionDialog extends StatefulWidget {
  final String title;
  final String hintText;
  final String? initialValueName;
  final List<dynamic> options;
  final Function(int id, String name)? onSelected;

  const DocumentSelectOptionDialog({
    super.key,
    required this.title,
    required this.hintText,
    this.initialValueName,
    required this.options,
    this.onSelected,
  });

  @override
  State<DocumentSelectOptionDialog> createState() => _DocumentSelectOptionDialogState();
}

class _DocumentSelectOptionDialogState extends State<DocumentSelectOptionDialog> {
  int? _selectedId;
  String? _selectedName;

  @override
  void initState() {
    super.initState();
    if (widget.initialValueName != null) {
      try {
        final found = widget.options.firstWhere(
          (opt) => opt['name'] == widget.initialValueName,
        );
        _selectedId = found['id'];
        _selectedName = found['name'];
      } catch (_) {
        // Not found
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: AppColors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(
                    Icons.close,
                    ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Dropdown
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.grey.withValues(alpha: 0.3)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  isExpanded: true,
                  hint: Text(widget.hintText, style: const TextStyle(color: AppColors.grey, fontSize: 14)),
                  value: _selectedId,
                  items: widget.options.map((opt) {
                    return DropdownMenuItem<int>(
                      value: opt['id'],
                      child: Text(opt['name'] ?? ''),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedId = val;
                      _selectedName = widget.options.firstWhere((opt) => opt['id'] == val)['name'];
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Select Button
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: () {
                  if (_selectedId != null && _selectedName != null) {
                    widget.onSelected?.call(_selectedId!, _selectedName!);
                    Navigator.of(context).pop();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Xác nhận',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
