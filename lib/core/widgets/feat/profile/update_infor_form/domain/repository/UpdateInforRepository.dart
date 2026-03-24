import 'dart:async';
import '../model/UserProfile.dart';

abstract class UpdateInforRepository {
  Future<void> updateProfile({
    required String userName,
    required String fullName,
    required String email,
    required String phoneNumber,
    required String address,
    required String? gender,
    required DateTime? birthDate,
    required String? school,
  });

  Future<UserProfile> getProfile();

  Future<List<String>> getSchoolList();
}

class UpdateInforRepositoryImpl extends UpdateInforRepository {
  // Mock local data
  UserProfile _mockProfile = UserProfile(
    userName: "duydev",
    fullName: "Lâm Bảo Duy",
    email: "duy@example.com",
    phoneNumber: "0123456789",
    address: "TP. Hồ Chí Minh",
    gender: "Nam",
    birthDate: DateTime(2002, 10, 15),
    school: "Đại học Công nghệ TP.HCM",
  );

  final List<String> _mockSchoolList = [
    "Đại học Công nghệ TP.HCM",
    "Đại học Bách Khoa",
    "Đại học Khoa Học Tự Nhiên",
    "Đại học Sư phạm Kỹ thuật",
    "Đại học Văn Lang",
    "Đại học FPT",
  ];

  @override
  Future<UserProfile> getProfile() async {
    await Future.delayed(const Duration(milliseconds: 500)); // giả lập API

    return _mockProfile;
  }

  @override
  Future<List<String>> getSchoolList() async {
    await Future.delayed(const Duration(milliseconds: 400)); // giả lập API

    return _mockSchoolList;
  }

  @override
  Future<void> updateProfile({
    required String userName,
    required String fullName,
    required String email,
    required String phoneNumber,
    required String address,
    required String? gender,
    required DateTime? birthDate,
    required String? school,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600)); // giả lập API PUT

    // Cập nhật dữ liệu mock
    _mockProfile = UserProfile(
      userName: userName,
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      address: address,
      gender: gender,
      birthDate: birthDate,
      school: school,
    );
  }
}
