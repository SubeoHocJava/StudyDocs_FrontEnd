


import 'package:file_picker/file_picker.dart';
import 'package:studydocs/data/datasource/follow_remote_datasource.dart';
import 'package:studydocs/data/datasource/impl/asset_remote_datasource_impl.dart';
import 'package:studydocs/data/datasource/impl/document_remote_datasource_impl.dart';
import 'package:studydocs/data/datasource/impl/follow_remote_datasource_impl.dart';
import 'package:studydocs/data/datasource/impl/user_remote_datasource_impl.dart';
import 'package:studydocs/data/datasource/user_remote_datasource.dart';
import 'package:studydocs/data/model/auth/request/update_user_request.dart';

import 'package:studydocs/features/profile/domain/model/profile_entity.dart';
import 'package:studydocs/features/profile/domain/repository/profile_repository.dart';
import 'package:studydocs/features/profile/domain/model/document_profile.dart';

import '../../../../../core/network/dio_client.dart';

import '../../../../../data/datasource/document_remote_datasource.dart';
import '../../../../../services/token_storage_service.dart';

class ProfileRepositoryImpl extends ProfileRepository {
  late final UserRemoteDataSource userRemoteDataSource;
  late final DocumentRemoteDataSource documentDataSource;
  late final FollowRemoteDataSource followDataSource;
  ProfileRepositoryImpl() {
    final dioClient = DioClient();
    userRemoteDataSource = UserDataSourceImpl(
      dioClient: dioClient,
      assetRemoteDataSource: AssetRemoteDataSourceImpl(dioClient: dioClient),
    );
    followDataSource= FollowRemoteDataSourceImpl(dioClient: dioClient);
    documentDataSource=DocumentRemoteDataSourceImpl(dioClient: dioClient);
  }



  @override
  Future<ProfileEntity> getProfile(int userId) async {
    try {
      final tokenStorage = TokenStorageService();
      final storedUserId = await tokenStorage.getUserId();

      if (storedUserId == null) {
        throw Exception('User ID not found in local storage');
      }

      // print('User ID from storage: $storedUserId');

      final response =
      await userRemoteDataSource.getUserById(storedUserId);
      final countFollower = await followDataSource.countFollowers(storedUserId);
      final countFollowing = await followDataSource.countFollowing(storedUserId);
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
          countFollower: countFollower ?? 0,
          countFollowing: countFollowing ?? 0,
          countDocument: userData['countDocument'] ?? 0,
          countLike: userData['countLike'] ?? 0,
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

      final response = await userRemoteDataSource.updateUser(request);
      
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
          countFollower: profile.countFollower,
          countFollowing: profile.countFollowing,
          countDocument: profile.countDocument,
          countLike: profile.countLike,
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

   await userRemoteDataSource.uploadImage(
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
  Future<int> followUser(String followingId) async {
    final tokenStorage = TokenStorageService();
    final storedUserId = await tokenStorage.getUserId();

    if (storedUserId == null) {
      throw Exception('User not logged in');
    }
    await followDataSource.follow(followerId: storedUserId, followingId: followingId);
    return await followDataSource.countFollowers(followingId);
  }

  @override
  Future<int> unfollowUser(String followingId) async {
    final tokenStorage = TokenStorageService();
    final storedUserId = await tokenStorage.getUserId();
    if (storedUserId == null) {
      throw Exception('User not logged in');
    }
    await followDataSource.deleteFollow(followerId: storedUserId, followingId: followingId);
    return await followDataSource.countFollowers(followingId);
  }

  @override
  Future<List<DocumentProfile>> getDocumentsByUser(String id) async {
    try {
      final docs = await documentDataSource.getMyDocuments();

      List<DocumentProfile> res= docs.map((doc) {
        return DocumentProfile(
          id: doc.id,
          title: doc.title,
          category: doc.category ?? '',
          institution: doc.institution ?? '',
          pages: doc.pageCount ?? 0,
          createdAt: doc.createdAt ?? '',
          likesCount: doc.likesCount ?? 0,
          commentsCount: doc.commentsCount ?? 0,
          thumbnailUrl: doc.thumbnailUrl,
        );
      }).toList();

      print("Log này của file: ProfileRepositoryImpl: đã load được document: "+res.length.toString());
      return res;
    } catch (e) {
      // In case of error, you might want to return an empty list or rethrow
      // For now, I'll log and return empty list or mock data if acceptable
      print('Log này của file: ProfileRepositoryImpl: Error fetching user documents: $e');
      return [];
    }
  }
}
