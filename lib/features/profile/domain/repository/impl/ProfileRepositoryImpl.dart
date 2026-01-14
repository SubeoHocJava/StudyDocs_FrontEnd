import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:studydocs/data/datasource/user_datasource.dart';
import 'package:studydocs/data/datasource/impl/asset_remote_datasource_impl.dart';
import 'package:studydocs/data/model/auth/request/update_user_request.dart';
import 'package:studydocs/features/profile/domain/model/profile_entity.dart';
import 'package:studydocs/features/profile/domain/repository/profile_repository.dart';
import 'package:studydocs/features/profile/domain/model/document_profile.dart';

import '../../../../../core/network/dio_client.dart';
import '../../../../../services/token_storage_service.dart';

class ProfileRepositoryImpl extends ProfileRepository {
  late final UserDataSource userDataSource;

  /// Constructor rỗng
  ProfileRepositoryImpl() {
    final dioClient = DioClient();
    userDataSource = UserDataSourceImpl(
      dioClient: dioClient,
      assetRemoteDataSource: AssetRemoteDataSourceImpl(dioClient: dioClient),
    );
  }

  final List<DocumentProfile> _mockDocuments = [
    DocumentProfile(
      id: 'doc_1',
      title: 'Lập trình Flutter cơ bản',
      category: 'Mobile',
      institution: 'ĐH Công Nghệ Thông Tin',
      pages: 120,
      createdAt: '2025-01-01',
      likesCount: 45,
      commentsCount: 10,
      thumbnailUrl: 'https://picsum.photos/200/300',
    ),
    DocumentProfile(
      id: 'doc_2',
      title: 'Java OOP nâng cao',
      category: 'Backend',
      institution: 'ĐH Công Nghệ Thông Tin',
      pages: 200,
      createdAt: '2025-02-10',
      likesCount: 78,
      commentsCount: 22,
      thumbnailUrl: 'https://picsum.photos/200/301',
    ),
    DocumentProfile(
      id: 'doc_3',
      title: 'Cấu trúc dữ liệu & Giải thuật',
      category: 'Computer Science',
      institution: 'ĐH Công Nghệ Thông Tin',
      pages: 300,
      createdAt: '2025-03-15',
      likesCount: 120,
      commentsCount: 35,
      thumbnailUrl: 'https://picsum.photos/200/302',
    ),
  ];
  @override
  Future<ProfileEntity> getProfile(int userId) async {
    try {
      final tokenStorage = TokenStorageService();
      final storedUserId = await tokenStorage.getUserId();

      if (storedUserId == null) {
        throw Exception('User ID not found in local storage');
      }

      print('User ID from storage: $storedUserId');

      final response =
      await userDataSource.getUserById(storedUserId);

      if (response.statusCode >= 200 &&
          response.statusCode < 300 &&
          response.data != null) {

        final userData = response.data;

        return ProfileEntity(
          id: userData['id']?.toString() ?? '',
          username: userData['username'] ?? '',
          fullName: userData['fullName'] ?? '',
          email: userData['email'] ?? '',
          phoneNumber: userData['phoneNumber'] ?? '',
          gender: userData['gender'] ?? '',
          birthDate: userData['dateOfBirth'] != null
              ? DateTime.tryParse(userData['dateOfBirth'])
              : null,
          address: userData['address'] ?? '',
          avatarUrl: userData['avatarUrl'] ?? '',
          isVerified: userData['isVerified'] ?? false,
          isFollowing: userData['isFollowing'] ?? false,
          school: userData['school']??'',
        );
      } else {
        throw Exception(
          'Failed to get profile. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error getting profile: $e');
    }
  }


  @override
  Future<ProfileEntity> updateProfile(ProfileEntity profile) async {
    try {
      final request = UpdateUserRequest(
        id: profile.id,
        username: profile.username,
        fullName: profile.fullName,
        email: profile.email,
        phoneNumber: profile.phoneNumber,
        gender: profile.gender,
        dateOfBirth: profile.birthDate,
        address: profile.address,
        avatarUrl: profile.avatarUrl,
        school: profile.school,
      );

      final response = await userDataSource.updateUser(request);
      
      // Check if statusCode is in success range (200-299)
      if (response.statusCode >= 200 && response.statusCode < 300 && response.data != null) {
        final userData = response.data;
        return ProfileEntity(
          id: userData['id']?.toString() ?? profile.id,
          username: userData['username'] ?? profile.username,
          fullName: userData['fullName'] ?? profile.fullName,
          email: userData['email'] ?? profile.email,
          phoneNumber: userData['phoneNumber'] ?? profile.phoneNumber,
          gender: userData['gender'] ?? profile.gender,
          birthDate: userData['dateOfBirth'] != null
              ? DateTime.tryParse(userData['dateOfBirth']) 
              : profile.birthDate,
          address: userData['address'] ?? profile.address,
          avatarUrl: userData['avatarUrl'] ?? profile.avatarUrl,
          isVerified: userData['isVerified'] ?? false,
          isFollowing: userData['isFollowing'] ?? false,
          school: userData['school'] ?? "Chưa nhập thông tin trường",
        );
      } else {
        throw Exception('Failed to update profile. Status: ${response.statusCode}, Error: ${response.errorCode}');
      }
    } catch (e) {
      throw Exception('Error updating profile: $e');
    }
  }

  @override
  Future<PlatformFile> updateAvatar(PlatformFile imagePath) async {
    final tokenStorage = TokenStorageService();
    final storedUserId = await tokenStorage.getUserId();

    if (storedUserId == null) {
      throw Exception('User not logged in');
    }

   await userDataSource.uploadImage(
      storedUserId,
      imagePath,
    );

    return imagePath;
  }


  @override
  Future<void> verifyEmail() async {
    try {
      // TODO: Implement email verification endpoint
      throw UnimplementedError('Email verification not yet implemented');
    } catch (e) {
      throw Exception('Error verifying email: $e');
    }
  }

  @override
  Future<void> followUser(String userId) async {
    try {
      // TODO: Implement follow user endpoint
      // This should call a follow service endpoint
      throw UnimplementedError('Follow user not yet implemented');
    } catch (e) {
      throw Exception('Error following user: $e');
    }
  }

  @override
  Future<void> unfollowUser(String userId) async {
    try {
      // TODO: Implement unfollow user endpoint
      // This should call a follow service endpoint
      throw UnimplementedError('Unfollow user not yet implemented');
    } catch (e) {
      throw Exception('Error unfollowing user: $e');
    }
  }

  @override
  List<DocumentProfile> getDocumentsByUser(String id) {
    // TODO: Implement real document fetching from API
    return _mockDocuments;
  }
}
