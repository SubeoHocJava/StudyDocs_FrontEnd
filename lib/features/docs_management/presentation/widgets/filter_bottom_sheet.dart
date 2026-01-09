import 'package:flutter/material.dart';

class FilterBottomSheet extends StatefulWidget {
  final Function(String? school, String? subject, String? year) onApply;

  const FilterBottomSheet({super.key, required this.onApply});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  final TextEditingController _schoolController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      // Giả lập style rounded top corners like screenshot
      decoration: const BoxDecoration(
        color: Color(0xFFE8EAF6), // Light blue-ish background
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Bộ lọc nâng cao",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3F51B5), // Dark blue text
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
          const SizedBox(height: 20),
          _buildFilterField("Trường học", "Nhập tên trường", _schoolController, Icons.school),
          const SizedBox(height: 12),
          _buildFilterField("Môn học", "Nhập tên môn học", _subjectController, Icons.folder),
          const SizedBox(height: 12),
          _buildFilterField("Năm học", "Chọn năm học", _yearController, Icons.calendar_today),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                widget.onApply(
                  _schoolController.text.isEmpty ? null : _schoolController.text,
                  _subjectController.text.isEmpty ? null : _subjectController.text,
                  _yearController.text.isEmpty ? null : _yearController.text,
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3F51B5), // Dark blue
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Áp dụng", style: TextStyle(fontSize: 16)),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom), // Avoid keyboard
        ],
      ),
    );
  }

  Widget _buildFilterField(String label, String hint, TextEditingController controller, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[700]),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
                labelText: label, // Optional: floating label
              ),
            ),
          ),
        ],
      ),
    );
  }
}
