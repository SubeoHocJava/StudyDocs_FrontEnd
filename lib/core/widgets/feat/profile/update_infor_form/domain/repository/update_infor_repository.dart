import 'dart:async';
import '../../../../../../../data/datasource/user_remote_datasource.dart';
import '../../../../../../../data/datasource/impl/user_remote_datasource_impl.dart';
import '../../../../../../../data/datasource/academic_remote_datasource.dart';
import '../../../../../../../data/datasource/impl/academic_remote_datasource_impl.dart';
import '../model/user_profile.dart';

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
  final AcademicRemoteDataSource academicDataSource;

  UpdateInforRepositoryImpl({
    UserRemoteDataSource? dataSource,
    AcademicRemoteDataSource? academicSource,
  }) : userDataSource = dataSource ?? UserRemoteDataSourceImpl(),
       academicDataSource = academicSource ?? AcademicRemoteDataSourceImpl();

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
      birthDate:
          user['dateOfBirth'] != null
              ? DateTime.tryParse(user['dateOfBirth'].toString())
              : null,
      school: user['school'] ?? "",
    );
  }

  @override
  Future<List<String>> getSchoolList() async {
    try {
      final response = await academicDataSource.getUniversities();
      if (response is List) {
        return response
            .map((e) => e['name']?.toString() ?? '')
            .where((name) => name.isNotEmpty)
            .toList();
      }
      if (response is Map && response['content'] is List) {
        return (response['content'] as List)
            .map((e) => e['name']?.toString() ?? '')
            .where((name) => name.isNotEmpty)
            .toList();
      }
      return [];
    } catch (e) {
      return [];
    }
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
    await userDataSource.updateUser(null, {
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
