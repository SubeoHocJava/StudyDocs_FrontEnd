import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart'; // Ensure url_launcher is available or use generic launch logic
import '../../data/model/document_model.dart';
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
              onChanged: (_) => _parseDocument(), // Re-parse if this changes logic
            ),
             const SizedBox(height: 10),
             TextField(
              controller: _fileIdController,
              decoration: const InputDecoration(labelText: "File ID", border: OutlineInputBorder()),
              onChanged: (_) => _parseDocument(),
            ),

            const SizedBox(height: 20),
            const SizedBox(height: 20),
            _buildSectionTitle("Resulting URLs (Loop Check)"),
            _buildInfoRow("Download URL", document.downloadUrl),
            const SizedBox(height: 8),
            const Text("Generated Preview URLs:", style: TextStyle(fontWeight: FontWeight.bold)),
            if (document.previewUrls.isEmpty)
              const Text("No URLs generated", style: TextStyle(color: Colors.red))
            else
              ...document.previewUrls.asMap().entries.map((entry) => Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: SelectableText("Page ${entry.key + 1}: ${entry.value}", style: const TextStyle(fontSize: 12)),
              )),

            const SizedBox(height: 20),
            _buildSectionTitle("Actions"),
            if (document.downloadUrl.isNotEmpty)
              Center(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final uri = Uri.parse(document.downloadUrl);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Could not launch $uri")));
                    }
                  },
                  icon: const Icon(Icons.download),
                  label: const Text("Download File"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                ),
              )
            else
               const Text("No Download URL available", style: TextStyle(color: Colors.red)),

            const SizedBox(height: 20),
            _buildSectionTitle("Preview Render (Page 1)"),
            Container(
              height: 400,
              width: double.infinity,
              decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
              child: previewUrl.isNotEmpty 
              ? CachedNetworkImage(
                imageUrl: previewUrl,
                fit: BoxFit.contain,
                placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 50),
                    const SizedBox(height: 8),
                    Text("Failed to load:\n$url", textAlign: TextAlign.center),
                  ],
                ),
              )
              : const Center(child: Text("No Preview URL to render")),
            ),
          ],
        ),
      ),
    );
  }

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
