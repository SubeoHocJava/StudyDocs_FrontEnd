import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/utils/responsive_helper.dart';

import '../../../../core/constants/app_colors.dart';
import '../../logic/upload_file_bloc.dart';
import '../../logic/upload_file_event.dart';

class MoreDetail extends StatefulWidget {
  const MoreDetail({super.key});

  @override
  State<MoreDetail> createState() => _MoreDetailState();
}

class _MoreDetailState extends State<MoreDetail> {
  final _formKey = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final yearCtrl = TextEditingController();
  final descCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Center(
      child: SizedBox(
        width: responsive.widthPercent(responsive.isMobile ? 80 : 160),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ===== Tên tài liệu =====
              Text("Tên tài liệu",
                style: TextStyle(
                  fontSize: responsive.fontSize(18),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: responsive.heightPercent(1)),
              TextFormField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  hintText: "Nhập tên ngắn gọn và đúng nội dung",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Vui lòng nhập tên tài liệu";
                  }
                  if (value.length < 3) return "Tên quá ngắn";
                  return null;
                },
              ),
              SizedBox(height: responsive.heightPercent(2)),

              // ===== Năm học =====
              Text("Năm học",
                style: TextStyle(
                  fontSize: responsive.fontSize(18),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: responsive.heightPercent(1)),
              TextFormField(
                controller: yearCtrl,
                decoration: InputDecoration(
                  hintText: "Chọn năm học",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Vui lòng nhập năm học";
                  }
                  if (!RegExp(r'^\d{4}-\d{4}$').hasMatch(value)) {
                    return "Định dạng đúng: 2023-2024";
                  }
                  return null;
                },
              ),
              SizedBox(height: responsive.heightPercent(2)),

              // ===== Mô tả =====
              Text("Mô tả",
                style: TextStyle(
                  fontSize: responsive.fontSize(18),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: responsive.heightPercent(1)),
              TextFormField(
                controller: descCtrl,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Mô tả ngắn gọn về tài liệu",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Vui lòng nhập mô tả";
                  }
                  if (value.length < 10) {
                    return "Mô tả ít nhất 10 ký tự";
                  }
                  return null;
                },
              ),
              SizedBox(height: responsive.heightPercent(2)),

              // ===== BUTTON =====
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<UploadFileBloc>().add(
                        SendFormUpload(
                          nameCtrl.text.trim(),
                          yearCtrl.text.trim(),
                          descCtrl.text.trim(),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: Size(
                      responsive.widthPercent(30),
                      responsive.widthPercent(30) * 1 / 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Xác nhận",
                    style: TextStyle(
                      fontSize: responsive.fontSize(16),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
