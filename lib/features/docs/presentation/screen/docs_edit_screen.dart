import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/constants/app_colors.dart';
import '../../domain/entity/document_entity.dart';
import '../../logic/docs_bloc.dart';
import '../../logic/docs_event.dart';

class DocsEditScreen extends StatefulWidget {
  final DocumentEntity doc;

  const DocsEditScreen({super.key, required this.doc});

  @override
  State<DocsEditScreen> createState() => _DocsEditScreenState();
}

class _DocsEditScreenState extends State<DocsEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _yearController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.doc.title);
    _descController = TextEditingController(text: widget.doc.description);
    _yearController = TextEditingController(text: widget.doc.year);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      context.read<DocsBloc>().add(UpdateDocument(
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        year: _yearController.text.trim(),
      ));
      Navigator.pop(context); // Close dialog/screen
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đang cập nhật tài liệu...')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chỉnh sửa tài liệu"),
        actions: [
          TextButton(
            onPressed: _onSave,
            child: const Text('Lưu', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               _buildLabel("Tên tài liệu"),
               TextFormField(
                 controller: _titleController,
                 decoration: const InputDecoration(
                   border: OutlineInputBorder(),
                   hintText: 'Nhập tên tài liệu',
                 ),
                 validator: (val) {
                   if (val == null || val.trim().isEmpty) return 'Vui lòng nhập tên';
                   if (val.length < 3) return 'Tên quá ngắn';
                   return null;
                 },
               ),
               const SizedBox(height: 16),

               _buildLabel("Năm học"),
               TextFormField(
                 controller: _yearController,
                 decoration: const InputDecoration(
                   border: OutlineInputBorder(),
                   hintText: 'Ví dụ: 2024-2025',
                 ),
                 validator: (val) {
                   if (val == null || val.trim().isEmpty) return 'Vui lòng nhập năm học';
                   // Basic format check if needed
                   return null;
                 },
               ),
               const SizedBox(height: 16),

               _buildLabel("Mô tả"),
               TextFormField(
                 controller: _descController,
                 maxLines: 5,
                 decoration: const InputDecoration(
                   border: OutlineInputBorder(),
                   hintText: 'Mô tả chi tiết về tài liệu...',
                 ),
                 validator: (val) {
                   if (val == null || val.trim().isEmpty) return 'Vui lòng nhập mô tả';
                   return null;
                 },
               ),
               const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }
}
