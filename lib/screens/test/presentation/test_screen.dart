import 'package:flutter/material.dart';
import 'package:studydocs/core/widgets/feat/document/upload_form/presentation/upload_form_with_bloc.dart';
import 'package:studydocs/data/datasource/document_upload_datasource.dart';

/// Page test tạm để kiểm tra điều hướng và widget upload form.
class TestScreen extends StatelessWidget {
  final String? fileName;
  final String? filePath;

  const TestScreen({
    super.key,
    this.fileName,
    this.filePath,
  });

  @override
  Widget build(BuildContext context) {
    final uploadRepository = DocumentUploadDatasource();
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Test'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: UploadFormWithBloc(
          repository: uploadRepository,
          initialFileName: fileName,
          initialFilePath: filePath,
        ),
      ),
    );
  }
}

