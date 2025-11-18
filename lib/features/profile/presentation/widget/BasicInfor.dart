import 'package:flutter/material.dart';
import 'package:studydocs/core/utils/responsive_helper.dart';
import 'package:studydocs/features/profile/presentation/widget/UpdateInforDialog.dart';

class BasicInfor extends StatelessWidget {
  const BasicInfor({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    const image = "icons/avt.png";
    const name = "";
    const school = "";

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.widthPercent(5),
        vertical: responsive.heightPercent(2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// ================= TOP RIGHT EDIT BUTTON =================
          Align(
            alignment: Alignment.topRight,
            child: TextButton.icon(
              onPressed: () => _showUpdateForm(context),
              icon: Icon(Icons.edit, size: responsive.fontSize(16)),
              label: Text(
                "Cập nhật thông tin",
                style: TextStyle(fontSize: responsive.fontSize(13)),
              ),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.widthPercent(2),
                  vertical: responsive.heightPercent(1),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),

          SizedBox(height: responsive.heightPercent(1)),

          /// ================= AVATAR =================
          Container(
            width: responsive.widthPercent(30),
            height: responsive.widthPercent(30),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: image.isNotEmpty
                  ? DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.cover,
              )
                  : null,
              color: Colors.grey.shade300,
            ),
            child: image.isEmpty
                ? Icon(
              Icons.person,
              size: responsive.widthPercent(20),
              color: Colors.grey.shade700,
            )
                : null,
          ),

          SizedBox(height: responsive.heightPercent(1.5)),

          /// ================= NAME =================
          Text(
            name.isNotEmpty ? name : "Tên chưa cập nhật",
            style: TextStyle(
              fontSize: responsive.fontSize(18),
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),

          /// ================= SCHOOL =================
          Text(
            school.isNotEmpty ? school : "Chưa có trường học",
            style: TextStyle(
              color: Colors.blueAccent,
              fontSize: responsive.fontSize(15),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

void _showUpdateForm(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => UpdateInforDialog(),
  );
}
