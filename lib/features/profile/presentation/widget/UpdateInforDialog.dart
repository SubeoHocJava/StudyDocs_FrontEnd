import 'package:flutter/material.dart';
import 'package:studydocs/features/profile/logic/profile_bloc.dart';
import '../../../../core/constants/app_colors.dart';
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
    if (bloc.state is ProfileLoaded) {
      final state = bloc.state as ProfileLoaded;
      fullNameController.text = state.fullName;
      emailController.text = state.email;
      userNameController.text = state.userName;
      phoneNumberController.text = state.phoneNumber;
      addressController.text = state.address;
      schoolController.text = state.school ?? '';
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
          contentPadding: EdgeInsets.zero,
          titlePadding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
          actionsPadding: const EdgeInsets.only(bottom: 16, top: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actionsAlignment: MainAxisAlignment.center,

          // ================= TITLE =================
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
                icon: const Icon(Icons.close_rounded,
                    size: 35, color: Colors.black87),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),

          // ================= FORM =================
          content: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label("Tên tài khoản"),
                  _input(
                    controller: userNameController,
                    hint: "Nhập tên tài khoản",
                    validator: _requiredValidator("tên tài khoản"),
                  ),

                  _label("Họ và tên"),
                  _input(
                    controller: fullNameController,
                    hint: "Nhập họ và tên",
                    validator: _requiredValidator("họ và tên"),
                  ),

                  _label("Email"),
                  _input(
                    controller: emailController,
                    hint: "Nhập email",
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Email không được để trống";
                      }
                      final regex =
                      RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                      if (!regex.hasMatch(value)) {
                        return "Email không hợp lệ";
                      }
                      return null;
                    },
                  ),

                  _label("Số điện thoại"),
                  _input(
                    controller: phoneNumberController,
                    hint: "Nhập số điện thoại",
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Vui lòng nhập số điện thoại";
                      }
                      if (!RegExp(r'^[0-9]{9,11}$').hasMatch(value)) {
                        return "Số điện thoại không hợp lệ (9–11 số)";
                      }
                      return null;
                    },
                  ),

                  // ===== SCHOOL (BẮT BUỘC) =====
                  _label("Trường học"),
                  _input(
                    controller: schoolController,
                    hint: "Nhập trường học",
                    validator: _requiredValidator("trường học"),
                  ),

                  // ===== GENDER (BẮT BUỘC) =====
                  FormField<String>(
                    validator: (_) {
                      if (selectedGender == null) {
                        return "Vui lòng chọn giới tính";
                      }
                      return null;
                    },
                    builder: (state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _label("Giới tính"),
                          Row(
                            children: [
                              Radio<String>(
                                value: "Nam",
                                groupValue: selectedGender,
                                onChanged: (value) {
                                  setState(() {
                                    selectedGender = value;
                                    state.didChange(value);
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
                                    state.didChange(value);
                                  });
                                },
                              ),
                              const Text("Nữ"),
                            ],
                          ),
                          if (state.hasError)
                            Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Text(
                                state.errorText!,
                                style: const TextStyle(
                                    color: Colors.red, fontSize: 12),
                              ),
                            ),
                        ],
                      );
                    },
                  ),

                  _label("Ngày sinh"),
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
                        validator: (_) =>
                        selectedDate == null
                            ? "Vui lòng chọn ngày sinh"
                            : null,
                        decoration: InputDecoration(
                          hintText: selectedDate == null
                              ? "Chọn ngày sinh"
                              : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                          suffixIcon:
                          const Icon(Icons.calendar_today),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                  ),

                  _label("Địa chỉ"),
                  _input(
                    controller: addressController,
                    hint: "Nhập địa chỉ",
                    validator: _requiredValidator("địa chỉ"),
                  ),
                ],
              ),
            ),
          ),

          // ================= ACTION =================
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
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
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

  // ================= HELPERS =================
  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 4, top: 12),
    child: Text(text,
        style: const TextStyle(fontWeight: FontWeight.bold)),
  );

  Widget _input({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) =>
      TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      );

  String? Function(String?) _requiredValidator(String fieldName) {
    return (value) =>
    value == null || value.trim().isEmpty
        ? "Vui lòng nhập $fieldName"
        : null;
  }
}
