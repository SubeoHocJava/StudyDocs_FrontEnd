import 'package:flutter/material.dart';

class SubjectLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width; //screen size
    return Center(
      child: Container(
        width: screenWidth * 0.8,
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.folder),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    "Môn học",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton(
                  onPressed: () => {},
                  child: Text(
                    "Chỉnh sửa",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            TextField(
              decoration: InputDecoration(
                labelText: "Môn học: ", // nhãn
                hintText: "Tìm theo tên hoạc mã môn học", // gợi ý
                border: OutlineInputBorder(
                  // viền
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
