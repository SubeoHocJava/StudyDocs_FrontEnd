import 'package:flutter/material.dart';

import '../../logic/update_infor_state.dart';

class UpdateInforViewModel {
  final TextEditingController fullName = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController userName = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController address = TextEditingController();

  DateTime? birthDate;
  String? gender;
  String? school;

  List<String> schoolList = [];

  // ====== INIT FROM PROFILE ======
  void loadFromProfile(UpdateInforLoaded state) {
    final profile = state.profile;

    fullName.text = profile.fullName;
    email.text = profile.email;
    userName.text = profile.userName;
    phone.text = profile.phoneNumber;
    address.text = profile.address;

    birthDate = profile.birthDate;
    gender = profile.gender;

    // Tránh null list
    schoolList = state.schoolList;

    // Kiểm tra school có nằm trong list hay không
    school = schoolList.contains(profile.school) ? profile.school : null;
  }


  // ====== VALIDATION ======
  String? validateRequired(String field, String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Vui lòng nhập $field";
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Vui lòng nhập số điện thoại";
    }
    if (!RegExp(r'^[0-9]{9,11}$').hasMatch(value)) {
      return "Số điện thoại không hợp lệ (9–11 số)";
    }
    return null;
  }

  bool validateAll(GlobalKey<FormState> key) {
    return key.currentState?.validate() ?? false;
  }
}
