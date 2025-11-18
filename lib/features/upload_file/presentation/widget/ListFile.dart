
import 'package:flutter/material.dart';
import 'package:studydocs/core/constants/app_colors.dart';
import 'package:studydocs/core/utils/responsive_helper.dart';
import '../../../library/data/model/File.dart';

class FileUploadLabel extends StatelessWidget {
  final List<MyFile> files;

  const FileUploadLabel({super.key, required this.files});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Center(
      child:
            Container(
                height:files.length* 50, // responsive height per item
                width: responsive.widthPercent(responsive.isMobile ? 80 : 40),
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: files.length,
                  itemBuilder: (context, index) {
                    final file = files[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: responsive.heightPercent(0.5)),
                      child: MonoFile(file: file),
                    );
                  },
                ),
              )
    );
  }
}

class MonoFile extends StatelessWidget {
  final MyFile file;

  const MonoFile({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Container(
      padding: EdgeInsets.all(responsive.isMobile ? 8 : 12),
      decoration: BoxDecoration(
        color: AppColors.headerBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.headerBackground),
      ),
      child: Row(
        children: [
          Icon(Icons.file_present, size: responsive.fontSize(18)),
          SizedBox(width: responsive.widthPercent(2)),
          Expanded(
            child: Text(
              file.fileName,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: responsive.fontSize(14)),
            ),
          ),
          Icon(Icons.cancel, size: responsive.fontSize(18)),
        ],
      ),
    );
  }
}
