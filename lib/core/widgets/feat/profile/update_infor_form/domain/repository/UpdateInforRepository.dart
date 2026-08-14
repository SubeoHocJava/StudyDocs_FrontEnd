import 'dart:async';
import '../../../../../../../data/datasource/impl/user_datasource_impl.dart';
import '../../../../../../../data/datasource/user_remote_datasource.dart';
import '../model/UserProfile.dart';
import 'package:studydocs/core/network/dio_client.dart';
import 'package:studydocs/core/network/token_services.dart';
import 'package:studydocs/core/constants/api/user_api.dart';
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
  final UserDataSource userDataSource;

  UpdateInforRepositoryImpl({UserDataSource? dataSource}) 
      : userDataSource = dataSource ?? UserDatasourceImpl();

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
      userName: user.username ?? "",
      fullName: user.fullName ?? "",
      email: user.email ?? "",
      phoneNumber: user.phoneNumber ?? "",
      address: user.address ?? "",
      gender: user.gender ?? "Khác",
      birthDate: user.dateOfBirth,
      school: user.school ?? "",
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
    final dioClient = DioClient();
    final tokenService = TokenStorageService();
    final userId = await tokenService.getUserId();
    if (userId == null) throw Exception("User not logged in");
    
    final response = await dioClient.patch(
      UserEndpoints.updateInfo(userId),
      data: {
        'username': userName,
        'fullName': fullName,
        'email': email,
        'phoneNumber': phoneNumber,
        'address': address,
        'gender': gender,
        'dateOfBirth': birthDate?.toIso8601String(),
        'school': school,
      },
    );
    
    if (!response.isSuccess) {
      throw Exception("Cập nhật thông tin thất bại");
    }
  }
}
