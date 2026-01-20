import 'package:flutter/material.dart';
import 'package:studydocs/data/model/user.dart';
import 'package:studydocs/features/manage_user/logic/manage_user_bloc.dart';
import 'package:studydocs/features/manage_user/logic/manage_user_event.dart';

class DetailUserDialog extends StatefulWidget {
  final ManageUserBloc bloc;
  final UserModel user;

  const DetailUserDialog({
    super.key,
    required this.bloc,
    required this.user,
  });

  @override
  State<DetailUserDialog> createState() => _DetailUserDialogState();
}

class _DetailUserDialogState extends State<DetailUserDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController userNameController;
  late TextEditingController fullNameController;
  late TextEditingController emailController;
  late TextEditingController phoneNumberController;
  late TextEditingController addressController;

  String? selectedGender;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();

    final user = widget.user;

    userNameController = TextEditingController(text: user.username);
    fullNameController = TextEditingController(text: user.fullName);
    emailController = TextEditingController(text: user.email);
    phoneNumberController = TextEditingController(text: user.phoneNumber);
    addressController = TextEditingController(text: user.address);

    selectedGender = user.gender;
    selectedDate = user.dateOfBirth;
  }

  @override
  void dispose() {
    userNameController.dispose();
    fullNameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Dialog(
      backgroundColor: Theme.of(context).cardTheme.color,
      insetPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: screenWidth * 0.9),
        child: AlertDialog(
          backgroundColor: Theme.of(context).cardTheme.color,
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          titlePadding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
          actionsPadding: const EdgeInsets.only(bottom: 16, top: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actionsAlignment: MainAxisAlignment.center,

          // ---------- TITLE ----------
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Cập nhật thông tin",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, size: 32),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),

          // ---------- FORM ----------
          content: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  _buildLabel("Tên tài khoản"),
                  _buildTextField(
                    controller: userNameController,
                    hint: "Nhập tên tài khoản",
                    enabled: false,
                    validator: _requiredValidator,
                  ),

                  _buildLabel("Họ và tên"),
                  _buildTextField(
                    controller: fullNameController,
                    hint: "Nhập họ và tên",
                    validator: _requiredValidator,
                  ),

                  _buildLabel("Email"),
                  _buildTextField(
                    controller: emailController,
                    hint: "Nhập email",
                    enabled: false,
                    keyboardType: TextInputType.emailAddress,
                    validator: _emailValidator,
                  ),

                  _buildLabel("Số điện thoại"),
                  _buildTextField(
                    controller: phoneNumberController,
                    hint: "Nhập số điện thoại",
                    keyboardType: TextInputType.phone,
                    validator: _phoneValidator,
                  ),

                  _buildLabel("Giới tính"),
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

                  _buildLabel("Ngày sinh"),
                  GestureDetector(
                    onTap: _pickDate,
                    child: AbsorbPointer(
                      child: TextFormField(
                        validator: (_) =>
                        selectedDate == null ? "Vui lòng chọn ngày sinh" : null,
                        decoration: _inputDecoration(
                          selectedDate == null
                              ? "Chọn ngày sinh"
                              : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                          suffixIcon: const Icon(Icons.calendar_today),
                        ),
                      ),
                    ),
                  ),

                  _buildLabel("Địa chỉ"),
                  _buildTextField(
                    controller: addressController,
                    hint: "Nhập địa chỉ",
                    validator: _requiredValidator,
                  ),
                ],
              ),
            ),
          ),

          // ---------- ACTION ----------
          actions: [
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                padding:
                const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "Cập nhật",
                style: TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).colorScheme.onPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================== HELPERS ==================

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final updatedUser = widget.user.copyWith(
      username: userNameController.text.trim(),
      fullName: fullNameController.text.trim(),
      email: emailController.text.trim(),
      phoneNumber: phoneNumberController.text.trim(),
      address: addressController.text.trim(),
      gender: selectedGender,
      dateOfBirth: selectedDate,
    );

    widget.bloc.add(UpdateUser(updatedUser));
    Navigator.pop(context);
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(top: 12, bottom: 4),
    child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
  );

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    bool enabled = true,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      enabled: enabled,
      validator: validator,
      style: TextStyle(
        color: enabled ? null : Colors.grey[700],
      ),
      decoration: _inputDecoration(
        hint,
        filled: !enabled,
        fillColor: enabled ? null : Colors.grey[200],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint,
      {Widget? suffixIcon, bool filled = false, Color? fillColor}) {
    return InputDecoration(
      hintText: hint,
      suffixIcon: suffixIcon,
      filled: filled,
      fillColor: fillColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey[400]!),
      ),
    );
  }

  String? _requiredValidator(String? value) =>
      value == null || value.trim().isEmpty ? "Không được để trống" : null;

  String? _emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) return "Email không được để trống";
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    return regex.hasMatch(value) ? null : "Email không hợp lệ";
  }

  String? _phoneValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Vui lòng nhập số điện thoại";
    }
    final regex = RegExp(r'^[0-9]{9,11}$');
    return regex.hasMatch(value)
        ? null
        : "Số điện thoại phải từ 9–11 chữ số";
  }
}
