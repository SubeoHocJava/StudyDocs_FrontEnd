import 'package:flutter/material.dart';
import 'package:studydocs/features/profile/logic/profile_bloc.dart';
import '../../logic/profile_event.dart';
import '../../logic/profile_state.dart';

class UpdateInforDialog extends StatefulWidget {
  final ProfileBloc bloc;
  const UpdateInforDialog({super.key, required this.bloc});

  @override
  State<UpdateInforDialog> createState() => _UpdateInforDialogState();
}

class _UpdateInforDialogState extends State<UpdateInforDialog> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  DateTime? selectedDate;
  String? selectedGender;
  String? selectedSchool;

  ProfileBloc get bloc => widget.bloc;

  @override
  void initState() {
    super.initState();

    if (bloc.state is ProfileLoaded) {
      final state = bloc.state as ProfileLoaded;

      fullNameController.text = state.fullName;
      emailController.text = state.email;
      userNameController.text = state.userName;
      phoneNumberController.text = state.phoneNumber;
      addressController.text = state.address;

      selectedDate = state.birthDate;
      selectedGender = state.gender;

      // ✅ FIX: chỉ set school nếu tồn tại trong list
      if (state.schools.contains(state.school)) {
        selectedSchool = state.school;
      } else {
        selectedSchool = null;
      }
    }
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
              Text(
                "Cập nhật thông tin",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.close_rounded,
                  size: 35,
                  color: Theme.of(context).iconTheme.color,
                ),
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
                    validator: _required("tên tài khoản"),
                  ),

                  _label("Họ và tên"),
                  _input(
                    controller: fullNameController,
                    hint: "Nhập họ và tên",
                    validator: _required("họ và tên"),
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

                  // ================= SCHOOL =================
                  if (bloc.state is ProfileLoaded) ...[
                    _label("Trường học"),
                    _buildSchoolDropdown(bloc.state as ProfileLoaded),
                  ],

                  // ================= GENDER =================
                  FormField<String>(
                    validator: (_) =>
                    selectedGender == null ? "Vui lòng chọn giới tính" : null,
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
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
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
                        selectedDate == null ? "Vui lòng chọn ngày sinh" : null,
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

                  _label("Địa chỉ"),
                  _input(
                    controller: addressController,
                    hint: "Nhập địa chỉ",
                    validator: _required("địa chỉ"),
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

                bloc.add(
                  UpdateProfile(
                    userName: userNameController.text.trim(),
                    fullName: fullNameController.text.trim(),
                    email: emailController.text.trim(),
                    phoneNumber: phoneNumberController.text.trim(),
                    gender: selectedGender,
                    birthDate: selectedDate,
                    address: addressController.text.trim(),
                    school: selectedSchool,
                  ),
                );

                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
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

  // ================= SCHOOL DROPDOWN =================

  Widget _buildSchoolDropdown(ProfileLoaded state) {
    final schools = state.schools.toSet().toList(); // ✅ remove duplicates

    return FormField<String>(
      validator: (_) =>
      selectedSchool == null ? "Vui lòng chọn trường học" : null,
      builder: (fieldState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              isExpanded: true,
              value: schools.contains(selectedSchool) ? selectedSchool : null,
              items: schools
                  .map(
                    (school) => DropdownMenuItem<String>(
                  value: school,
                  child: Text(school),
                ),
              )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedSchool = value;
                  fieldState.didChange(value);
                });
              },
              decoration: InputDecoration(
                hintText: "Chọn trường học",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            if (fieldState.hasError)
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 4),
                child: Text(
                  fieldState.errorText!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
          ],
        );
      },
    );
  }

  // ================= HELPERS =================

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 4, top: 12),
    child: Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.bold),
    ),
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

  String? Function(String?) _required(String field) =>
          (value) => value == null || value.trim().isEmpty
          ? "Vui lòng nhập $field"
          : null;
}
