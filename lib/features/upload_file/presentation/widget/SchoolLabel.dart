import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/utils/responsive_helper.dart';

import '../../logic/upload_file_bloc.dart';
import '../../logic/upload_file_event.dart';

class SchoolLabel extends StatelessWidget {
  final String school;
  const SchoolLabel({super.key, required this.school});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    return Center(
      child: Container(
        width: responsive.widthPercent(responsive.isMobile ? 80 : 160),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.school, size: responsive.fontSize(20)),
                SizedBox(width: responsive.widthPercent(2)),
                Expanded(
                  child: Text(
                    "Trường học",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: responsive.fontSize(18),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    final bloc = context.read<UploadFileBloc>();
                    TextEditingController _controller = TextEditingController();
                    showDialog(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return AlertDialog(
                          title: Text("Chỉnh sửa trường học"),
                          content: TextField(
                            controller: _controller,
                            decoration: InputDecoration(
                              labelText: "Nhập dữ liệu",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(dialogContext).pop(),
                              child: Text("Hủy"),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                bloc.add(
                                  EditSchoolLabel(_controller.text),
                                ); //
                                Navigator.of(dialogContext).pop();
                              },
                              child: Text("Lưu"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text(
                    "Chỉnh sửa",
                    style: TextStyle(
                      fontSize: responsive.fontSize(14),
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: responsive.heightPercent(1)),
            Row(
              children: [
                Text(
                 school,
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: responsive.fontSize(16),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
