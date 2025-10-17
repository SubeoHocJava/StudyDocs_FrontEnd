import 'package:flutter/material.dart';

class SchoolLabel extends StatelessWidget {
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
                Icon(Icons.school),
          SizedBox(width: 16),
                Expanded(
                  child: Text(
                    "Trường học",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 20, // 👈 kích thước chữ
                      fontWeight: FontWeight.bold, // 👈 in đậm (tuỳ chọn)
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => {},
                  child: Text(
                    "Chỉnh sửa",
                    style: TextStyle(fontSize: 16,color: Colors.blueAccent,fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  "Trường đại học nông lâm",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
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
