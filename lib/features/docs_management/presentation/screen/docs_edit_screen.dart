import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../docs/domain/entity/document_entity.dart';
import '../../logic/docs_management_bloc.dart';
import '../../logic/docs_management_event.dart';

class DocsEditScreen extends StatefulWidget {
  final DocumentEntity? document; // Null if creating new

  const DocsEditScreen({super.key, this.document});

  @override
  State<DocsEditScreen> createState() => _DocsEditScreenState();
}

class _DocsEditScreenState extends State<DocsEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _schoolController;
  late TextEditingController _yearController;
  late TextEditingController _subjectController; // Only in design for Detail, maybe useful here?
  // Design also shows "Tác giả" in Detail, but normally edit form only has editable fields.

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.document?.title ?? "");
    _schoolController = TextEditingController(text: widget.document?.school ?? "Trường Đại học Nông Lâm Tp. HCM");
    _yearController = TextEditingController(text: widget.document?.year ?? "2024/2025");
    _subjectController = TextEditingController(text: widget.document?.course ?? "");
  }

  @override
  void dispose() {
    _titleController.dispose();
    _schoolController.dispose();
    _yearController.dispose();
    _subjectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          widget.document == null ? "Thêm tài liệu" : "Chỉnh sửa tài liệu",
          style: const TextStyle(color: Color(0xFF3F51B5), fontWeight: FontWeight.bold),
        ),
        actions: [
            IconButton(
            icon: const Icon(Icons.person_outline, color: Color(0xFF3F51B5)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.wb_sunny_outlined, color: Color(0xFF3F51B5)),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               // Title (Readonly or Editable? Assuming editable)
               if (widget.document != null) ...[
                 Text(widget.document!.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
               ] else ...[
                 _buildTextField("Tên tài liệu", _titleController),
               ],
               if (widget.document != null) ...[
                const SizedBox(height: 8),
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8)
                    ),
                    child: Row(
                        children:[
                            const Icon(Icons.description, color: Colors.grey),
                            const SizedBox(width: 8),
                             Expanded(child: Text(widget.document!.title, style: const TextStyle(color: Colors.grey)))
                        ]
                    )
                ),
               ],

               const SizedBox(height: 24),
               
               _buildLabel("Trường học"),
               Text(widget.document?.school ?? _schoolController.text, style: const TextStyle(color: Color(0xFF3F51B5), fontWeight: FontWeight.bold)),
               // If completely editable form:
               // _buildTextField("Trường học", _schoolController),

               const SizedBox(height: 16),
                _buildLabel("Môn học"),
                Text(widget.document?.course ?? _subjectController.text, style: const TextStyle(color: Color(0xFF3F51B5), fontWeight: FontWeight.bold)),
               // _buildTextField("Môn học", _subjectController),
               
               // But wait, the UI design screenshot shows "Chỉnh sửa" button leading to a form-like view? 
               // Or does the "Screen 4" in prompt imply the form?
               // The screenshot 4 shows "Cập nhật" button and fields.
               // Let's implement full fields based on screenshot 4.
               
               _buildTextField("Tiêu đề (File)", _titleController, icon: Icons.description, enabled: false), // Disabled as file name usually fixed unless re-uploaded
               const SizedBox(height: 16),
               
               _buildLabel("Trường học"),
               _buildTextField("Trường học", _schoolController, icon: Icons.school),
               
               const SizedBox(height: 16),
               _buildLabel("Môn học"),
               _buildTextField("Môn học", _subjectController, icon: Icons.folder),

                const SizedBox(height: 16),
               _buildLabel("Năm học"),
                // Dropdown or text field for year
               _buildYearSelector(),

                const SizedBox(height: 16),
                _buildLabel("Tác giả:"),
                Row(
                    children: [
                         const CircleAvatar(
                             backgroundImage: AssetImage('assets/images/google.png'), // Placeholder
                             radius: 20,
                         ),
                         const SizedBox(width: 12),
                         Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                                 const Text("Subeo Dangiu", style: TextStyle(fontWeight: FontWeight.bold)),
                                 Text(widget.document?.school ?? "Trường ĐH...", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                             ],
                         )
                    ],
                ),

                const SizedBox(height: 40),
                SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                             // Dispatch Update Event
                             final updatedDoc = widget.document!.copyWith(
                                 school: _schoolController.text,
                                 course: _subjectController.text,
                                 year: _yearController.text,
                                 // title: file name usually not changed here
                             );
                             context.read<DocsManagementBloc>().add(UpdateDocEvent(widget.document!.title, updatedDoc));
                             
                             Navigator.pop(context);
                             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Đã cập nhật tài liệu")));
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0000AA), // Deep Blue
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))
                        ),
                        child: const Text("Cập nhật", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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

  Widget _buildTextField(String hint, TextEditingController controller, {IconData? icon, bool enabled = true}) {
    return Container(
      decoration: BoxDecoration(
          color: enabled ? Colors.white : Colors.grey.shade100,
          border: Border(bottom: BorderSide(color: Colors.grey.shade300))
      ),
        child: TextField(
            controller: controller,
            enabled: enabled,
            decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
                prefixIcon: icon != null ? Icon(icon, color: Colors.grey) : null,
                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12)
            ),
        )
    );
  }

  Widget _buildYearSelector() {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(24)
        ),
        child: Text(_yearController.text)
      );
  }
}
