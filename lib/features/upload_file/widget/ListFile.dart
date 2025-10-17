import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../model/File.dart';

class FileUploadLabel extends StatelessWidget {
  final List<MyFile> files;

  const FileUploadLabel({super.key, required this.files});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width; //screen size
    return Center(
      child: Container(
        height: 100,
        width: screenWidth * 0.8,
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: files.length,
          itemBuilder: (context, index) {
            final file = files[index];
            return MonoFile(file: file);
          },
        ),
      ),
    );
  }
}

class MonoFile extends StatelessWidget {
  final MyFile file;

  const MonoFile({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width; //screen size
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.05),
      decoration: BoxDecoration(
        color: AppColors.headerBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.headerBg),
      ),
      child:Row(
        children: [
          Icon(Icons.file_present),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              file.fileName,
              overflow: TextOverflow.ellipsis, // 👈 để tránh tràn chữ
            ),
          ),
          Icon(Icons.cancel),
        ],
      ),
    );
  }
}
