import 'package:flutter/material.dart';

class MoreDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width; // screen size
    return Center(
      child: Container(
        width: screenWidth * 0.8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // căn full width
          children: [
            Text(
              "Tên tài liệu",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: "Tên tài liệu ",
                hintText: "Tìm theo tên hoạc mã môn học",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Năm học",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: "Năm học: ",
                hintText: "Tìm theo tên hoạc mã môn học",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 16), // 👈 khoảng cách 16px
            Text(
              "Mô tả",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextField(
              maxLines: null, // hoặc 5 nếu muốn giới hạn
              decoration: InputDecoration(
                labelText: "Mô tả: ",
                hintText: "Tìm theo tên hoạc mã môn học",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.center, // hoặc Alignment.center
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  minimumSize: Size(120, 70),
                  // width, height
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Xác nhận",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
