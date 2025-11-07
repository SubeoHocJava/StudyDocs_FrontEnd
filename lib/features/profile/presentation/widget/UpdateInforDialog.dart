import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class UpdateInforDialog extends StatefulWidget {
  const UpdateInforDialog({super.key});

  @override
  State<UpdateInforDialog> createState() => _UpdateInforDialogState();
}

class _UpdateInforDialogState extends State<UpdateInforDialog> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  DateTime? selectedDate;
  String? selectedGender; // "Nam" hoặc "Nữ"

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Dialog(
      backgroundColor: AppColors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ConstrainedBox(

        constraints: BoxConstraints(
          maxWidth: screenWidth * 0.9,
        ),
        child: AlertDialog(
          backgroundColor: AppColors.white,
          insetPadding: EdgeInsets.zero,
          contentPadding: const EdgeInsets.all(0),
          titlePadding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
          actionsPadding: const EdgeInsets.only(bottom: 16, top: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actionsAlignment: MainAxisAlignment.center,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Cập nhật thông tin",
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.close_rounded,
                  size: 35,
                  color: Colors.black87,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Tên tài khoản ---
                const Text("Tên tài khoản",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                TextField(
                  controller: userNameController,
                  decoration: InputDecoration(
                    hintText: "Nhập tên tài khoản",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // --- Họ và tên ---
                const Text("Họ và tên",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                TextField(
                  controller: fullNameController,
                  decoration: InputDecoration(
                    hintText: "Nhập họ và tên",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // --- Email ---
                const Text("Email",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: "Nhập email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 12),

                // --- Số điện thoại ---
                const Text("Số điện thoại",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                TextField(
                  controller: phoneNumberController,
                  decoration: InputDecoration(
                    hintText: "Nhập số điện thoại",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 12),

                // --- Giới tính ---
                const Text("Giới tính",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Radio<String>(
                            value: "Nam",
                            groupValue: selectedGender,
                            onChanged: (value) {
                              setState(() {
                                selectedGender = value;
                              });
                            },
                          ),
                          const Text("Nam"),
                          Radio<String>(
                            value: "Nữ",
                            groupValue: selectedGender,
                            onChanged: (value) {
                              setState(() {
                                selectedGender = value;
                              });
                            },
                          ),
                          const Text("Nữ"),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // --- Ngày sinh ---
                const Text("Ngày sinh",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate ?? DateTime(2000),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() {
                        selectedDate = picked;
                      });
                    }
                  },
                  child: AbsorbPointer(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: selectedDate == null
                            ? "Chọn ngày sinh"
                            : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                        suffixIcon: const Icon(Icons.calendar_today),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // --- Địa chỉ ---
                const Text("Địa chỉ",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                TextField(
                  controller: addressController,
                  decoration: InputDecoration(
                    hintText: "Nhập địa chỉ",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                debugPrint("Tên tài khoản: ${userNameController.text}");
                debugPrint("Họ và tên: ${fullNameController.text}");
                debugPrint("Email: ${emailController.text}");
                debugPrint("SĐT: ${phoneNumberController.text}");
                debugPrint("Giới tính: $selectedGender");
                debugPrint(
                  "Ngày sinh: ${selectedDate != null ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}" : 'Chưa chọn'}",
                );
                debugPrint("Địa chỉ: ${addressController.text}");
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
              ),
              child: const Text(
                "Cập nhật",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
