
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/constants/app_colors.dart';
import 'package:studydocs/core/utils/responsive_helper.dart';

import '../../logic/upload_file_bloc.dart';
import '../../logic/upload_file_event.dart';


class FileUploadLabel extends StatelessWidget {
  final List<PlatformFile> files;

  const FileUploadLabel( {super.key, required this.files});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Center(
      child:
            Container(
                height:files.length* 60, // responsive height per item
                width: responsive.widthPercent(responsive.isMobile ? 80 : 40),
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: files.length,
                  itemBuilder: (context, index) {
                    final file = files[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: responsive.heightPercent(0.5)),
                      child: MonoFile(file: file,index:index),
                    );
                  },
                ),
              )
    );
  }
}

class MonoFile extends StatelessWidget {
  final PlatformFile file;
  final int index;
  const MonoFile({super.key, required this.file,  required this.index});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Container(
      padding: EdgeInsets.all(responsive.isMobile ? 1 : 2),
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
              file.name,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: responsive.fontSize(14)),
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete_forever, size: responsive.fontSize(18),color: Colors.red,),
            onPressed: () {
              context.read<UploadFileBloc>().add(RemovePickDocument(index));
              print("Cancel pressed");
            },
          )

        ],
      ),
    );
  }
}
