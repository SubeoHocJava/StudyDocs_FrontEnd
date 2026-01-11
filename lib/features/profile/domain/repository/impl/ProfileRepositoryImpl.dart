import 'dart:async';

import 'package:studydocs/features/profile/domain/model/profile_entity.dart';
import 'package:studydocs/features/profile/domain/repository/profile_repository.dart';
import 'package:studydocs/features/profile/domain/model/document_profile.dart';

class ProfileRepositoryImpl extends ProfileRepository {

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

  ProfileEntity _mockProfile = ProfileEntity(
    id: '1',
    username: 'lamduy',
    fullName: 'Lâm Bảo Duy',
    school: 'ĐH Công Nghệ Thông Tin',
    email: 'lamduy@gmail.com',
    phoneNumber: '0123456789',
    gender: 'MALE',
    birthDate: DateTime(2001, 5, 20),
    address: 'TP. Hồ Chí Minh',
    avatarUrl: 'https://i.pravatar.cc/150?img=3',
    isVerified: false,
    isFollowing: false,
  );

  @override
  Future<ProfileEntity> getProfile(int userId) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return _mockProfile;
  }

  @override
  Future<ProfileEntity> updateProfile(ProfileEntity profile) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockProfile = profile;
    return _mockProfile;
  }

  @override
  Future<String> updateAvatar(String imagePath) async {
    await Future.delayed(const Duration(milliseconds: 500));

    _mockProfile = ProfileEntity(
      id: _mockProfile.id,
      username: _mockProfile.username,
      fullName: _mockProfile.fullName,
      school: _mockProfile.school,
      email: _mockProfile.email,
      phoneNumber: _mockProfile.phoneNumber,
      gender: _mockProfile.gender,
      birthDate: _mockProfile.birthDate,
      address: _mockProfile.address,
      avatarUrl: 'https://i.pravatar.cc/150?img=8',
      isVerified: _mockProfile.isVerified,
      isFollowing: _mockProfile.isFollowing,
    );

    return _mockProfile.avatarUrl;
  }

  @override
  Future<void> verifyEmail() async {
    await Future.delayed(const Duration(milliseconds: 400));

    _mockProfile = ProfileEntity(
      id: _mockProfile.id,
      username: _mockProfile.username,
      fullName: _mockProfile.fullName,
      school: _mockProfile.school,
      email: _mockProfile.email,
      phoneNumber: _mockProfile.phoneNumber,
      gender: _mockProfile.gender,
      birthDate: _mockProfile.birthDate,
      address: _mockProfile.address,
      avatarUrl: _mockProfile.avatarUrl,
      isVerified: true,
      isFollowing: _mockProfile.isFollowing,
    );
  }

  @override
  Future<void> followUser(String userId) async {

    await Future.delayed(const Duration(milliseconds: 500));
    _mockProfile = ProfileEntity(
      id: _mockProfile.id,
      username: _mockProfile.username,
      fullName: _mockProfile.fullName,
      school: _mockProfile.school,
      email: _mockProfile.email,
      phoneNumber: _mockProfile.phoneNumber,
      gender: _mockProfile.gender,
      birthDate: _mockProfile.birthDate,
      address: _mockProfile.address,
      avatarUrl: _mockProfile.avatarUrl,
      isVerified: _mockProfile.isVerified,
      isFollowing: true,
    );
  }

  @override
  Future<void> unfollowUser(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockProfile = ProfileEntity(
      id: _mockProfile.id,
      username: _mockProfile.username,
      fullName: _mockProfile.fullName,
      school: _mockProfile.school,
      email: _mockProfile.email,
      phoneNumber: _mockProfile.phoneNumber,
      gender: _mockProfile.gender,
      birthDate: _mockProfile.birthDate,
      address: _mockProfile.address,
      avatarUrl: _mockProfile.avatarUrl,
      isVerified: _mockProfile.isVerified,
      isFollowing: false,
    );
  }

  @override
  List<DocumentProfile> getDocumentsByUser(String id) {
    return _mockDocuments;
  }
}
