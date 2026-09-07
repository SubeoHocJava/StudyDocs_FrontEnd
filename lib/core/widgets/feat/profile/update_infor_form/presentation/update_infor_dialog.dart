import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../constants/app_colors.dart';
import '../domain/model/update_infor_view_model.dart';
import '../logic/update_infor_bloc.dart';
import '../logic/update_infor_event.dart';
import '../logic/update_infor_state.dart';

class UpdateInforDialog extends StatefulWidget {
  const UpdateInforDialog({super.key});

  @override
  State<UpdateInforDialog> createState() => _UpdateInforDialogState();
}

class _UpdateInforDialogState extends State<UpdateInforDialog> {
  final _formKey = GlobalKey<FormState>();
  final model = UpdateInforViewModel();

  @override
  void initState() {
    super.initState();
    context.read<UpdateInforBloc>().add(LoadUpdateInfor());
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocConsumer<UpdateInforBloc, UpdateInforState>(
      listener: (context, state) {
        if (state is UpdateInforLoaded) {
          model.loadFromProfile(state);
        }

        if (state is UpdateSuccess) {
          Navigator.of(context, rootNavigator: true).pop(true);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Cập nhật thành công")));
        }

        if (state is UpdateError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        /// ===== INITIAL =====
        if (state is UpdateInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        /// ===== LOADING =====
        if (state is UpdateLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        /// ===== ERROR =====
        if (state is UpdateError) {
          return Center(
            child: Text(
              "Lỗi: ${state.message}",
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: screenWidth * 0.9,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: _buildAlert(context),
            ),
          ),
        );
      },
    );
  }

  // ================= ALERT CONTENT =================
  Widget _buildAlert(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      elevation: 0,
      insetPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      actionsAlignment: MainAxisAlignment.center,
      title: _buildTitle(context),
      content: _buildForm(context),
      actions: [_buildSubmitButton(context)],
    );
  }

  // ================= TITLE =================
  Widget _buildTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Cập nhật thông tin",
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.close_rounded,
            size: 35,
            color: AppColors.textPrimaryLight,
          ),
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
        ),
      ],
    );
  }

  // ================= FORM =================
  Widget _buildForm(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label("Tên tài khoản"),
            _input(
              model.userName,
              "Nhập tên tài khoản",
              (v) => model.validateRequired("tên tài khoản", v),
            ),

            _label("Họ và tên"),
            _input(
              model.fullName,
              "Nhập họ và tên",
              (v) => model.validateRequired("họ và tên", v),
            ),

            _label("Số điện thoại"),
            _input(
              model.phone,
              "Nhập số điện thoại",
              model.validatePhone,
              keyboardType: TextInputType.phone,
            ),

            _label("Trường học"),
            _buildSchoolDropdown(),

            _label("Giới tính"),
            _buildGenderSection(),

            _label("Ngày sinh"),
            _buildBirthDate(),

            _label("Địa chỉ"),
            _input(
              model.address,
              "Nhập địa chỉ",
              (v) => model.validateRequired("địa chỉ", v),
            ),
          ],
        ),
      ),
    );
  }

  // ================= SCHOOL DROPDOWN =================
  Widget _buildSchoolDropdown() {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      initialValue: model.school,
      dropdownColor: AppColors.white,
      items:
          model.schoolList
              .map(
                (school) => DropdownMenuItem(
                  value: school,
                  child: Text(
                    school,
                    style: TextStyle(color: AppColors.textPrimaryLight),
                  ),
                ),
              )
              .toList(),
      onChanged: (value) => setState(() => model.school = value),
      validator: (v) => v == null ? "Vui lòng chọn trường học" : null,
      decoration: _inputDecoration("Chọn trường học"),
    );
  }

  // ================= GENDER =================
  Widget _buildGenderSection() {
    return FormField<String>(
      validator: (_) => model.gender == null ? "Vui lòng chọn giới tính" : null,
      builder:
          (state) => Column(
            children: [
              RadioGroup<String>(
                groupValue: model.gender,
                onChanged: (v) {
                  setState(() => model.gender = v);
                  state.didChange(v);
                },
                child: Row(
                  children: [
                    Radio<String>(
                      value: "Nam",
                      activeColor: AppColors.primary,
                    ),
                    Text(
                      "Nam",
                      style: TextStyle(color: AppColors.textPrimaryLight),
                    ),
                    Radio<String>(
                      value: "Nữ",
                      activeColor: AppColors.primary,
                    ),
                    Text(
                      "Nữ",
                      style: TextStyle(color: AppColors.textPrimaryLight),
                    ),
                  ],
                ),
              ),
              if (state.hasError)
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(
                    state.errorText!,
                    style: TextStyle(color: AppColors.danger, fontSize: 12),
                  ),
                ),
            ],
          ),
    );
  }

  // ================= DATE PICKER =================
  Widget _buildBirthDate() {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: model.birthDate ?? DateTime(2000),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
          builder:
              (context, child) => Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.light(
                    primary: AppColors.primary,
                    onPrimary: AppColors.white,
                    surface: AppColors.surfaceLight,
                    onSurface: AppColors.textPrimaryLight,
                  ),
                ),
                child: child!,
              ),
        );
        if (picked != null) setState(() => model.birthDate = picked);
      },
      child: AbsorbPointer(
        child: TextFormField(
          validator:
              (_) => model.birthDate == null ? "Vui lòng chọn ngày sinh" : null,
          style: TextStyle(color: AppColors.textPrimaryLight),
          decoration: _inputDecoration(
            model.birthDate == null
                ? "Chọn ngày sinh"
                : "${model.birthDate!.day}/${model.birthDate!.month}/${model.birthDate!.year}",
            suffixIcon: Icon(
              Icons.calendar_today,
              color: AppColors.textPrimaryLight,
            ),
          ),
        ),
      ),
    );
  }

  // ================= BUTTON =================
  Widget _buildSubmitButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () {
        if (!model.validateAll(_formKey)) return;

        context.read<UpdateInforBloc>().add(
          SubmitUpdateInfor(
            userName: model.userName.text.trim(),
            fullName: model.fullName.text.trim(),
            email: model.email.text.trim(),
            phoneNumber: model.phone.text.trim(),
            gender: model.gender,
            birthDate: model.birthDate,
            address: model.address.text.trim(),
            school: model.school,
          ),
        );
      },
      child: Text(
        "Cập nhật",
        style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.white),
      ),
    );
  }

  // ================= HELPERS =================
  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 4, top: 12),
    child: Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimaryLight,
      ),
    ),
  );

  InputDecoration _inputDecoration(String hint, {Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: AppColors.textSecondaryLight),
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.border),
        borderRadius: BorderRadius.circular(16),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  Widget _input(
    TextEditingController controller,
    String hint,
    String? Function(String?) validator, {
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(color: AppColors.textPrimaryLight),
      decoration: _inputDecoration(hint),
    );
  }
}
