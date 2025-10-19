import 'package:flutter/material.dart';

class Statistical extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: screenWidth * 0.3,
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                    color: Colors.greenAccent,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "12 người theo dõi",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(width: 2),
                // 🔹 Đường line ở giữa
                Container(
                  width: 2,
                  height: 60,
                  color: Colors.black,
                ),
                SizedBox(width: 2),
                Container(
                  width: screenWidth * 0.4,
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                    color: Colors.blue,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Đang theo dõi 56 người",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),
            ActivityStatistics(),
          ],
        ),
      ),
    );
  }
}

class ActivityStatistics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center();
  }
}
