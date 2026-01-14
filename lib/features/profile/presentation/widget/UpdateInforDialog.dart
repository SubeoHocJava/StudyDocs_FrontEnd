import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/features/profile/logic/profile_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../upload_file/logic/upload_file_bloc.dart';
import '../../logic/profile_event.dart';
import '../../logic/profile_state.dart';

class UpdateInforDialog extends StatefulWidget {
  final ProfileBloc bloc;
  const UpdateInforDialog({super.key, required this.bloc});

  @override
  State<UpdateInforDialog> createState() => _UpdateInforDialogState(bloc);
}

class _UpdateInforDialogState extends State<UpdateInforDialog> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController schoolController = TextEditingController();
  final ProfileBloc bloc;
  DateTime? selectedDate;
  String? selectedGender;

  _UpdateInforDialogState(this.bloc) {
    // Khởi tạo các controller với dữ liệu hiện tại nếu có
    if (bloc.state is ProfileLoaded) {
      final state = bloc.state as ProfileLoaded;
      fullNameController.text = state.fullName;
      emailController.text = state.email;
      userNameController.text = state.userName;
      phoneNumberController.text = state.phoneNumber;
      addressController.text = state.address;
      schoolController.text = state.school!;
      selectedDate = state.birthDate;
      selectedGender = state.gender;
    }
  }

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
        constraints: BoxConstraints(maxWidth: screenWidth * 0.9),
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
                    Icons.close_rounded, size: 35, color: Colors.black87),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),

          // ---------------- FORM ---------------- //
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // --- Tên tài khoản ---
                  const Text("Tên tài khoản",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  TextFormField(
                    controller: userNameController,
                    validator: (value) =>
                    value == null || value
                        .trim()
                        .isEmpty
                        ? "Vui lòng nhập tên tài khoản"
                        : null,
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
                  TextFormField(
                    controller: fullNameController,
                    validator: (value) =>
                    value == null || value
                        .trim()
                        .isEmpty
                        ? "Vui lòng nhập họ và tên"
                        : null,
                    decoration: InputDecoration(
                      hintText: "Nhập họ và tên",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // --- Email ---
                  const Text(
                      "Email", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value
                          .trim()
                          .isEmpty) {
                        return "Email không được để trống";
                      }
                      final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                      if (!regex.hasMatch(value)) {
                        return "Email không hợp lệ";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Nhập email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // --- Số điện thoại ---
                  const Text("Số điện thoại",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  TextFormField(
                    controller: phoneNumberController,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value
                          .trim()
                          .isEmpty) {
                        return "Vui lòng nhập số điện thoại";
                      }
                      final regex = RegExp(r'^[0-9]{9,11}$');
                      if (!regex.hasMatch(value)) {
                        return "Số điện thoại không hợp lệ (9–11 số)";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Nhập số điện thoại",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // --- Trường học ---
                  const Text("Trường học",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  TextFormField(
                    controller: schoolController,
                    decoration: InputDecoration(
                      hintText: "Nhập trường học",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // --- Giới tính ---
                  const Text("Giới tính",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      Radio<String>(
                        value: "Nam",
                        groupValue: selectedGender,
                        onChanged: (value) =>
                            setState(() => selectedGender = value),
                      ),
                      const Text("Nam"),
                      Radio<String>(
                        value: "Nữ",
                        groupValue: selectedGender,
                        onChanged: (value) =>
                            setState(() => selectedGender = value),
                      ),
                      const Text("Nữ"),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // --- Ngày sinh ---
                  const Text("Ngày sinh",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate ?? DateTime(2000),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setState(() => selectedDate = picked);
                      }
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        validator: (_) {
                          if (selectedDate == null)
                            return "Vui lòng chọn ngày sinh";
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: selectedDate == null
                              ? "Chọn ngày sinh"
                              : "${selectedDate!.day}/${selectedDate!
                              .month}/${selectedDate!.year}",
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
                  const Text(
                      "Địa chỉ", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  TextFormField(
                    controller: addressController,
                    validator: (value) =>
                    value == null || value
                        .trim()
                        .isEmpty
                        ? "Vui lòng nhập địa chỉ"
                        : null,
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
          ),

          actions: [
            ElevatedButton(
              onPressed: () {
                if (!_formKey.currentState!.validate()) return;
                bloc.add(UpdateProfile(
                  userName: userNameController.text.trim(),
                  fullName: fullNameController.text.trim(),
                  email: emailController.text.trim(),
                  phoneNumber: phoneNumberController.text.trim(),
                  gender: selectedGender,
                  birthDate: selectedDate,
                  address: addressController.text.trim(),
                  school: schoolController.text.trim(),
                ));
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 4,
              ),
              child: const Text(
                  "Cập nhật", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
