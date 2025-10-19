import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class BasicInfor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center, // căn giữa phần nội dung
      children: [
        // button update profile
        Align(
          alignment: Alignment.topRight,
          child: TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.edit, size: 18),
            label: const Text(
              "Cập nhật thông tin",
              style: TextStyle(fontSize: 13),
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              minimumSize: const Size(0, 36), // chiều cao nhỏ gọn
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        // avatar
        const SizedBox(height: 10),
        Image.asset(
          "assets/icons/avt.png",
          width: 120,
          height: 120,
          fit: BoxFit.cover,
        ),
        const SizedBox(height: 8),
        // name
        const Text(
          "Subeo xém đáng yêu",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        // school
        const Text(
          "Trường Đại học Nông Lâm",
          style: TextStyle(fontSize: 15, color: Colors.blueAccent),
        ),
      ],
    );
  }
}