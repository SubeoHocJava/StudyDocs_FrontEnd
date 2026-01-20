import 'package:file_picker/file_picker.dart';

import 'package:studydocs/data/datasource/academic_remote_datasource.dart';
import 'package:studydocs/data/datasource/asset_remote_datasource.dart';
import 'package:studydocs/data/datasource/document_remote_datasource.dart';
import 'package:studydocs/data/datasource/follow_remote_datasource.dart';
import 'package:studydocs/data/datasource/user_remote_datasource.dart';
import 'package:studydocs/data/datasource/docs_remote_datasource.dart';

import 'package:studydocs/data/datasource/impl/academic_remote_datasource_impl.dart';
import 'package:studydocs/data/datasource/impl/asset_remote_datasource_impl.dart';
import 'package:studydocs/data/datasource/impl/document_remote_datasource_impl.dart';
import 'package:studydocs/data/datasource/impl/follow_remote_datasource_impl.dart';
import 'package:studydocs/data/datasource/impl/user_remote_datasource_impl.dart';

import 'package:studydocs/data/model/auth/request/update_user_request.dart';
import 'package:studydocs/features/profile/domain/model/profile_entity.dart';
import 'package:studydocs/features/profile/domain/model/document_profile.dart';
import 'package:studydocs/features/profile/domain/repository/profile_repository.dart';
import 'package:studydocs/features/docs/data/model/document_model.dart';

import '../../../../../core/network/dio_client.dart';
import '../../../../../services/token_storage_service.dart';

class ProfileRepositoryImpl extends ProfileRepository {
  late final UserRemoteDataSource userRemoteDataSource;
  late final DocumentRemoteDataSource documentDataSource;
  late final FollowRemoteDataSource followDataSource;
  late final AssetRemoteDataSource assetRemoteDataSource;
  late final AcademicRemoteDataSource academicRemoteDataSource;
  late final DocsRemoteDataSource docsRemoteDataSource;

  ProfileRepositoryImpl() {
    final dioClient = DioClient();

    assetRemoteDataSource =
        AssetRemoteDataSourceImpl(dioClient: dioClient);

    academicRemoteDataSource =
        AcademicRemoteDataSourceImpl(dioClient: dioClient);

    docsRemoteDataSource =
        DocsRemoteDataSourceImpl(dioClient: dioClient);

    userRemoteDataSource = UserDataSourceImpl(
      dioClient: dioClient,
      assetRemoteDataSource: assetRemoteDataSource,
    );

    followDataSource =
        FollowRemoteDataSourceImpl(dioClient: dioClient);

    documentDataSource =
        DocumentRemoteDataSourceImpl(dioClient: dioClient);
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // PROFILE
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  @override
  Future<ProfileEntity> getProfile(String userId) async {
    final myUserId = await TokenStorageService().getUserId();

    final response = await userRemoteDataSource.getUserById(userId);
    final countFollower = await followDataSource.countFollowers(userId);
    final countFollowing = await followDataSource.countFollowing(userId);
    final isFollowing =
    await followDataSource.isFollowing(myUserId!, userId);

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
        isFollowing: isFollowing,
        school: userData['school'] ?? '',
        countFollower: countFollower,
        countFollowing: countFollowing,
        countDocument: userData['countDocument'] ?? 0,
        countLike: userData['countLike'] ?? 0,
      );
    }

    throw Exception(
      'Failed to get profile. Status: ${response.statusCode}',
    );
  }

  @override
  Future<ProfileEntity> updateProfile(ProfileEntity profile) async {
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

    if (response.statusCode >= 200 &&
        response.statusCode < 300 &&
        response.data != null) {
      final userData = response.data;

      return profile.copyWith(
        username: userData['username'],
        fullName: userData['fullName'],
        email: userData['email'],
        phoneNumber: userData['phoneNumber'],
        gender: userData['gender'],
        birthDate: userData['dateOfBirth'] != null
            ? DateTime.tryParse(userData['dateOfBirth'])
            : profile.birthDate,
        address: userData['address'],
        avatarUrl: userData['avatarUrl'],
        school: userData['school'],
      );
    }

    throw Exception('Failed to update profile');
  }

  @override
  Future<PlatformFile> updateAvatar(PlatformFile imagePath) async {
    final userId = await TokenStorageService().getUserId();
    if (userId == null) throw Exception('User not logged in');

    await userRemoteDataSource.uploadImage(userId, imagePath);
    return imagePath;
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // FOLLOW
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  @override
  Future<int> followUser(String followingId) async {
    final myUserId = await TokenStorageService().getUserId();
    if (myUserId == null) throw Exception('User not logged in');

    await followDataSource.follow(
      followerId: myUserId,
      followingId: followingId,
    );

    return followDataSource.countFollowers(followingId);
  }

  @override
  Future<int> unfollowUser(String followingId) async {
    final myUserId = await TokenStorageService().getUserId();
    if (myUserId == null) throw Exception('User not logged in');

    await followDataSource.deleteFollow(
      followerId: myUserId,
      followingId: followingId,
    );

    return followDataSource.countFollowers(followingId);
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // DOCUMENTS BY USER (WITH STATS)
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  @override
  Future<List<DocumentProfile>> getDocumentsByUser(String id) async {
    try {
      var documents = await documentDataSource.getMyDocuments();

      documents = await _enrichWithAssets(documents);
      documents = await _enrichWithStats(documents);

      final universityIds = documents
          .where((d) => d.universityId != null && d.universityId!.isNotEmpty)
          .map((d) => d.universityId!)
          .toSet()
          .toList();

      final subjectIds = documents
          .where((d) => d.subjectId != null && d.subjectId!.isNotEmpty)
          .map((d) => d.subjectId!)
          .toSet()
          .toList();

      final results = await Future.wait([
        _fetchUniversitiesByIds(universityIds),
        _fetchSubjectsByIds(subjectIds),
      ]);

      final universityMap = results[0];
      final subjectMap = results[1];

      return documents.map((doc) {
        final institution =
        doc.universityId != null
            ? universityMap[doc.universityId!] ?? doc.school
            : doc.school;

        final category =
        doc.subjectId != null
            ? subjectMap[doc.subjectId!] ?? doc.course
            : doc.course;

        return DocumentProfile(
          id: doc.id ?? '',
          fileId: doc.fileId,
          title: doc.title,
          category: category,
          institution: institution,
          pages: doc.pages,
          createdAt: doc.year,
          likesCount: doc.likes,
          commentsCount: doc.commentsCount ?? 0,
          thumbnailUrl:
          doc.previewUrls.isNotEmpty ? doc.previewUrls.first : null,
          isLiked: doc.currentUserReaction == 'LIKE',
          isSaved: doc.isSaved,
        );
      }).toList();
    } catch (e) {
      print('ProfileRepositoryImpl: Failed to load documents - $e');
      return [];
    }
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // HELPERS
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Future<List<DocumentModel>> _enrichWithStats(
      List<DocumentModel> docs,
      ) async {
    final futures = docs.map((doc) async {
      if (doc.id == null) return doc;

      try {
        final results = await Future.wait([
          docsRemoteDataSource.getDocumentStats(doc.id!),
          docsRemoteDataSource.getMyDocumentReaction(doc.id!),
          docsRemoteDataSource.getReviewCount(doc.id!),
        ]);

        final stats = results[0] as Map<String, dynamic>;
        final reaction = results[1] as String?;
        final commentCount = results[2] as int;

        final likes = (stats['likeCount'] as num?)?.toInt() ?? 0;
        final dislikes = (stats['dislikeCount'] as num?)?.toInt() ?? 0;

        return doc.copyWith(
          likes: likes,
          dislikes: dislikes,
          commentsCount: commentCount,
          currentUserReaction: reaction,
        );
      } catch (_) {
        return doc;
      }
    });

    return Future.wait(futures);
  }

  Future<List<DocumentModel>> _enrichWithAssets(
      List<DocumentModel> docs,
      ) async {
    final futures = docs.map((doc) async {
      if (doc.fileId != null && doc.fileId!.isNotEmpty) {
        try {
          final asset =
          await assetRemoteDataSource.getAssetById(doc.fileId!);
          if (asset.previewUrls.isNotEmpty) {
            return doc.copyWith(previewUrls: asset.previewUrls);
          }
        } catch (_) {}
      }
      return doc;
    });

    return Future.wait(futures);
  }

  Future<Map<String, String>> _fetchUniversitiesByIds(
      List<String> ids,
      ) async {
    if (ids.isEmpty) return {};

    final futures = ids.map((id) async {
      try {
        final uni =
        await academicRemoteDataSource.getUniversityById(id);
        return MapEntry(id, uni.name);
      } catch (_) {
        return MapEntry(id, 'Unknown University');
      }
    });

    return Map.fromEntries(await Future.wait(futures));
  }

  Future<Map<String, String>> _fetchSubjectsByIds(
      List<String> ids,
      ) async {
    if (ids.isEmpty) return {};

    final futures = ids.map((id) async {
      try {
        final subject =
        await academicRemoteDataSource.getSubjectById(id);
        return MapEntry(id, subject.name);
      } catch (_) {
        return MapEntry(id, 'Unknown Subject');
      }
    });

    return Map.fromEntries(await Future.wait(futures));
  }

  @override
  Future<List<String>> getSchools() {
    return academicRemoteDataSource.getSchools();
  }

  @override
  Future<void> verifyEmail() {
    throw UnimplementedError();
  }
}
