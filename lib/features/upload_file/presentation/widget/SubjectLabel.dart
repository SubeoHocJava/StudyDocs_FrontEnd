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
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        // Tạo một TextEditingController để lấy dữ liệu nhập vào
                        TextEditingController _controller = TextEditingController();

                        return AlertDialog(
                          title: Text("Chỉnh sửa thông tin"),
                          content: TextField(
                            controller: _controller,
                            decoration: InputDecoration(
                              labelText: "Nhập dữ liệu",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Đóng dialog
                              },
                              child: Text("Hủy"),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                print("Giá trị nhập: ${_controller.text}");
                                Navigator.of(context).pop(); // Đóng dialog sau khi lưu
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
                      fontSize: 16,
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
