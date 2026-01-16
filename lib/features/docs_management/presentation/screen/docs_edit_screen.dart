import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../docs/domain/entity/document_entity.dart';
import '../../logic/docs_management_bloc.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import '../../logic/docs_management_event.dart';
import '../../../docs/presentation/widgets/document_preview_widget.dart';

class DocsEditScreen extends StatefulWidget {
  final DocumentEntity? document; // Null if creating new

  const DocsEditScreen({super.key, this.document});

  @override
  State<DocsEditScreen> createState() => _DocsEditScreenState();
}

class _DocsEditScreenState extends State<DocsEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _schoolController;
  late TextEditingController _yearController;
  late TextEditingController _subjectController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.document?.title ?? "");
    _descriptionController = TextEditingController(text: widget.document?.description ?? "");
    _schoolController = TextEditingController(text: widget.document?.school ?? "Trường Đại học Nông Lâm Tp. HCM");
    _yearController = TextEditingController(text: widget.document?.year ?? "2024-2025");
    _subjectController = TextEditingController(text: widget.document?.course ?? "");
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _schoolController.dispose();
    _yearController.dispose();
    _subjectController.dispose();
    super.dispose();
  }

  PlatformFile? _selectedFile;

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        withData: true, // Critical for Web to get bytes
      );

      if (result != null) {
        setState(() {
          _selectedFile = result.files.single;
          if (_titleController.text.isEmpty) {
            _titleController.text = _selectedFile!.name;
          }
        });
      }
    } catch (e) {
      if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Lỗi chọn file: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isEditing = widget.document != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF3F51B5)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isEditing ? "Chỉnh sửa tài liệu" : "Thêm tài liệu",
          style: const TextStyle(color: Color(0xFF3F51B5), fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TITLE - Always allowed to edit
              _buildTextField("Tên tài liệu", _titleController),
              const SizedBox(height: 16),
              
              // DESCRIPTION - Always allowed to edit
              _buildTextField("Mô tả", _descriptionController, maxLines: 3),
              const SizedBox(height: 16),

              // FILE PICKER - Only for New Documents
              if (!isEditing) ...[
                 GestureDetector(
                   onTap: _pickFile,
                   behavior: HitTestBehavior.opaque,
                   child: Container(
                     padding: const EdgeInsets.all(16),
                     decoration: BoxDecoration(
                       border: Border.all(color: Colors.grey),
                       borderRadius: BorderRadius.circular(8),
                     ),
                     child: Row(
                       children: [
                         const Icon(Icons.upload_file),
                         const SizedBox(width: 8),
                         Expanded(child: Text(_selectedFile != null ? _selectedFile!.name : "Chọn file tài liệu (PDF, Docx...)")),
                       ],
                     ),
                   ),
                 ),
                 const SizedBox(height: 24),
              ],

              // SCHOOL / SUBJECT - Only for New Documents (Hidden/Read-only in Edit)
               if (!isEditing) ...[
                   _buildLabel("Trường học"),
                   _buildTextField("Trường học", _schoolController, icon: Icons.school),
                   const SizedBox(height: 16),
                   
                   _buildLabel("Môn học"),
                   _buildTextField("Môn học", _subjectController, icon: Icons.folder),
                   const SizedBox(height: 16),
               ] else ...[
                   // Optional: Show them as read-only info if needed, or keep hidden as per request "chỉ cho chỉnh sửa..."
                   // _buildLabel("Trường học (Không thể chỉnh sửa)"),
                   // Container(padding: EdgeInsets.all(12), child: Text(widget.document?.school ?? "", style: TextStyle(color: Colors.grey))),
                   // SizedBox(height: 16),
               ],
               
               if (isEditing && widget.document != null)
                 Padding(
                   padding: const EdgeInsets.only(bottom: 24.0),
                   child: DocumentPreviewWidget(
                     previewUrls: widget.document!.previewUrls,
                   ),
                 ),

                // SCHOOL YEAR - Always allowed to edit
               _buildLabel("Năm học"),
               _buildTextField("Năm học (VD: 2023-2024)", _yearController, icon: Icons.calendar_today),

                const SizedBox(height: 40),
                SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                             if (isEditing) {
                                 final updatedDoc = widget.document!.copyWith(
                                     title: _titleController.text,
                                     description: _descriptionController.text,
                                     // Fields hidden from UI, keep existing or default?
                                     // User asked to remove them, but backend might need them.
                                     // Keep existing if editing, or default if not changed.
                                     // Since controllers are gone, we use existing entity value.
                                     school: widget.document!.school, 
                                     course: widget.document!.course,
                                     year: _yearController.text,
                                 );
                                 context.read<DocsManagementBloc>().add(UpdateDocEvent(widget.document!.id!, updatedDoc));
                                 ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Đã cập nhật tài liệu")));
                             } else {
                               if (_selectedFile != null) {
                                  final newDoc = DocumentEntity(
                                    id: '', 
                                    title: _titleController.text,
                                    description: _descriptionController.text,
                                    school: _schoolController.text,
                                    course: _subjectController.text,
                                    year: _yearController.text,
                                    uploader: 'Me',
                                    likes: 0,
                                    dislikes: 0,
                                    comments: [],
                                    pages: 0,
                                    fileSize: '0 B',
                                    downloadUrl: '',
                                    fileId: '',
                                    previewUrls: [],
                                  );
                                  context.read<DocsManagementBloc>().add(UploadDocEvent(
                                    _selectedFile, 
                                    newDoc
                                  ));
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Đang tải tài liệu lên...")));
                               } else {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Vui lòng chọn file để tải lên")));
                               }
                             }
                             
                             if (isEditing) Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0000AA),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))
                        ),
                        child: Text(isEditing ? "Cập nhật" : "Tải lên", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
      return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      );
  }

  Widget _buildTextField(String hint, TextEditingController controller, {IconData? icon, bool enabled = true, int maxLines = 1}) {
    return Container(
      decoration: BoxDecoration(
          color: enabled ? Colors.white : Colors.grey.shade100,
          border: Border(bottom: BorderSide(color: Colors.grey.shade300))
      ),
        child: TextField(
            controller: controller,
            enabled: enabled,
            maxLines: maxLines,
            decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
                prefixIcon: icon != null ? Icon(icon, color: Colors.grey) : null,
                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12)
            ),
        )
    );
  }

}
