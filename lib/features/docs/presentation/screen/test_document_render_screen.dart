import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:studydocs/features/docs/data/model/document_model.dart';
import '../../domain/entity/document_entity.dart';

class TestRenderScreen extends StatefulWidget {
  const TestRenderScreen({super.key});

  @override
  State<TestRenderScreen> createState() => _TestRenderScreenState();
}

class _TestRenderScreenState extends State<TestRenderScreen> {
  // Mock Data
  late DocumentEntity document;
  final TextEditingController _cloudNameController = TextEditingController(text: "dzfynkkoc");
  final TextEditingController _fileIdController = TextEditingController(text: "f192e5b7-98be-4573-9753-c1b6ea675b22");

  @override
  void initState() {
    super.initState();
    _parseDocument();
  }

  void _parseDocument() {
    final Map<String, dynamic> mockJson = {
        "id": "dafd5c91-df2b-4760-b07d-bbb59002e0d1",
        "userId": "85334f01-6e62-4cda-8cb2-4e9b3864cb02",
        "title": "Test Upload Doc",
        "description": "Description",
        "fileId": "30302b5d-ba4e-4cfb-892f-965c791406fe",
        "status": "UPLOADED",
        "isDeleted": false,
        "schoolYear": "2023-2024",
        "createdAt": "2026-01-15T22:47:18.459616",
        "updatedAt": "2026-01-15T22:47:18.802428",
        // Correct UUID-based URL (No % encoding)
        "downloadUrl": "https://res.cloudinary.com/dzfynkkoc/image/upload/fl_attachment/83d7b9a1-2a16-4e15-a40c-4b3e2023a6b2",
        "previewDataView": {
            // Correct UUID-based Base URL
            "baseUrl": "https://res.cloudinary.com/dzfynkkoc/image/upload/pg_PAGE_NUMBER_PLACEHOLDER/83d7b9a1-2a16-4e15-a40c-4b3e2023a6b2",
            "key": "PAGE_NUMBER_PLACEHOLDER"
        },
        "totalPages": 1, 
        "subjectId": null,
        "universityId": null
    };
    
    setState(() {
      document = DocumentModel.fromJson(mockJson);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Correct Logic: Use the URL parsed by DocumentModel, not a hardcoded guess.
    // DocumentModel parses 'previewDataView' which contains the correct Cloudinary ID.
    final String previewUrl = document.previewUrls.isNotEmpty 
        ? document.previewUrls.first 
        : '';
    
    return Scaffold(
      appBar: AppBar(title: const Text("Test Document Render")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Configuration (Mock Data)"),
            const Text("This screen parses the Mock JSON below.", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 10),
             TextField(
              controller: _cloudNameController,
              decoration: const InputDecoration(labelText: "Cloud Name (if needed for fallback)", border: OutlineInputBorder()),
              onChanged: (_) => _parseDocument(), 
            ),
             const SizedBox(height: 10),
             TextField(
              controller: _fileIdController,
              decoration: const InputDecoration(labelText: "File ID", border: OutlineInputBorder()),
              onChanged: (_) => _parseDocument(),
            ),

            const SizedBox(height: 20),
            _buildSectionTitle("UI Simulation (DocsDetailScreen Logic)"),
            
            // SIMULATED UI
            Container(
              decoration: BoxDecoration(border: Border.all(color: Colors.purple, width: 2), borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                   const Text("Render Area", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple)),
                   const SizedBox(height: 10),
                   
                   // PDF VIEWER SIMULATOR
                   SizedBox(
                      height: 400,
                      child: PageView.builder(
                        // Logic from DocsDetailScreen
                        itemCount: _isExpanded ? document.previewUrls.length : (document.previewUrls.isNotEmpty ? 1 : 0),
                        physics: _isExpanded ? null : const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: CachedNetworkImage(
                                imageUrl: document.previewUrls[index],
                                fit: BoxFit.contain,
                                placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) => const Center(child: Icon(Icons.error, size: 50, color: Colors.red)),
                              ),
                            ),
                          );
                        },
                      ),
                   ),
                   
                   const SizedBox(height: 16),
                   
                   // SEE MORE BUTTON SIMULATOR
                   if (!_isExpanded)
                     OutlinedButton.icon(
                       onPressed: () {
                         setState(() {
                           _isExpanded = true;
                         });
                       },
                       icon: const Icon(Icons.expand_more),
                       label: const Text("Xem thêm chi tiết & Bình luận (Simulated)"),
                     ),
                     
                   // EXPANDED CONTENT SIMULATOR
                   if (_isExpanded) ...[
                      const SizedBox(height: 20),
                      const Divider(),
                      const Text("Bình luận (Visible only when expanded)", style: TextStyle(fontWeight: FontWeight.bold)),
                      Container(height: 100, color: Colors.grey.shade200, child: const Center(child: Text("[Comments Section Placeholder]"))),
                   ]
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            _buildSectionTitle("Debug Info"),
             _buildInfoRow("Mock Total Pages", document.pages.toString()),
             _buildInfoRow("Generated URLs Check", ""),
             ...document.previewUrls.take(3).map((u) => SelectableText("- $u", style: const TextStyle(fontSize: 10))),
          ],
        ),
      ),
    );
  }
  
  bool _isExpanded = false; // Added state logic

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$label:", style: const TextStyle(fontWeight: FontWeight.w600)),
          SelectableText(value, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
