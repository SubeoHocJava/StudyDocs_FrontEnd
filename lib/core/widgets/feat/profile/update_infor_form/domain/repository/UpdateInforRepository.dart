import 'dart:async';
import '../../../../../../../data/datasource/user_remote_datasource.dart';
import '../../../../../../../data/datasource/impl/user_remote_datasource_impl.dart';
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
  final UserRemoteDataSource userDataSource;

  UpdateInforRepositoryImpl({UserRemoteDataSource? dataSource}) 
      : userDataSource = dataSource ?? UserRemoteDataSourceImpl();

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
    final user = await userDataSource.getUser();
    return UserProfile(
      userName: user['username'] ?? "",
      fullName: user['fullName'] ?? "",
      email: user['email'] ?? "",
      phoneNumber: user['phoneNumber'] ?? "",
      address: user['address'] ?? "",
      gender: user['gender'] ?? "Khác",
      birthDate: user['dateOfBirth'] != null ? DateTime.tryParse(user['dateOfBirth'].toString()) : null,
      school: user['school'] ?? "",
    );
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
    await userDataSource.updateUser({
      'username': userName,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'gender': gender,
      'dateOfBirth': birthDate?.toIso8601String(),
      'school': school,
    });
  }
}
