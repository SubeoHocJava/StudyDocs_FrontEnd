import 'package:flutter/material.dart';
import '../../../docs/domain/entity/document_entity.dart';
import 'docs_edit_screen.dart';

class DocsManagementDetailScreen extends StatelessWidget {
  final DocumentEntity document;

  const DocsManagementDetailScreen({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Quản lý tài liệu",
          style: TextStyle(
            color: Color(0xFF3F51B5), // Match blueprint color
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF3F51B5)),
          onPressed: () => Navigator.pop(context),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    document.title.replaceAll('.pdf', ''), // Human, readable
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to Edit
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DocsEditScreen(document: document),
                      ),
                    );
                  },
                  child: const Text("Chỉnh sửa", style: TextStyle(color: Color(0xFF3F51B5))),
                )
              ],
            ),
            const SizedBox(height: 8),
            
            // Info tags
            Row(children: [
                 const Icon(Icons.folder, size: 16, color: Colors.black87),
                 const SizedBox(width: 4),
                 Text(document.course, style: const TextStyle(color: Colors.blue)),
            ]),
            const SizedBox(height: 4),
            Row(children: [
                 const Icon(Icons.school, size: 16, color: Colors.black87),
                 const SizedBox(width: 4),
                 Text(document.school, style: const TextStyle(color: Colors.blue)),
            ]),

            const SizedBox(height: 16),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    Text("Năm học: ${document.year}"),
                    Text("${document.pages} trang"),
                ],
            ),

            const SizedBox(height: 20),
            const Text("Đăng tải bởi:", style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Row(children: [
                const CircleAvatar(
                    child: Icon(Icons.person),
                ),
                const SizedBox(width: 12),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Text(document.uploader, style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text(document.school, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                    ],
                )
            ]),

            const SizedBox(height: 30),
            
            // PDF Preview (Mock Image)
            Container(
                width: double.infinity,
                height: 400,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            const Icon(Icons.picture_as_pdf, size: 64, color: Colors.red),
                            const SizedBox(height: 16),
                            const Text("PREVIEW PDF HERE"),
                             // In real app, reuse _buildPdfViewer from DocsDetailScreen
                             // But that widget is local to that screen.
                             // For now, placeholder is enough for Management UI structure.
                        ],
                    )
                ),
            )
          ],
        ),
      ),
    );
  }
}
