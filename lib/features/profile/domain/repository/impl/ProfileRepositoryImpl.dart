import 'dart:async';

import 'package:studydocs/features/profile/domain/model/profile_entity.dart';
import 'package:studydocs/features/profile/domain/repository/profile_repository.dart';

import '../../../../../data/model/document_model.dart';

class ProfileRepositoryImpl extends ProfileRepository {


  final  List<DocumentModel> _mockDocuments = [
    DocumentModel(
      id: 'doc_1',
      title: 'Lập trình Flutter cơ bản',
      description: 'Tài liệu nhập môn Flutter',
      author: 'Lâm Bảo Duy',
      authorId: '1',
      thumbnailUrl: 'https://picsum.photos/200/300',
      category: 'Mobile',
      institution: 'ĐH Công Nghệ Thông Tin',
      pageCount: 120,
      academicYear: '2024',
      viewCount: 1500,
      downloadCount: 320,
      likesCount: 45,
      commentsCount: 10,
      rating: 4.5,
      createdAt: '2025-01-01',
      fileType: 'PDF',
    ),
    DocumentModel(
      id: 'doc_2',
      title: 'Java OOP nâng cao',
      description: 'Nguyên lý OOP trong Java',
      author: 'Lâm Bảo Duy',
      authorId: '1',
      thumbnailUrl: 'https://picsum.photos/200/301',
      category: 'Backend',
      institution: 'ĐH Công Nghệ Thông Tin',
      pageCount: 200,
      academicYear: '2023',
      viewCount: 2300,
      downloadCount: 540,
      likesCount: 78,
      commentsCount: 22,
      rating: 4.7,
      createdAt: '2025-02-10',
      fileType: 'PDF',
    ),
    DocumentModel(
      id: 'doc_3',
      title: 'Cấu trúc dữ liệu & Giải thuật',
      description: 'Tài liệu CTDL GT',
      author: 'Lâm Bảo Duy',
      authorId: '1',
      category: 'Computer Science',
      institution: 'ĐH Công Nghệ Thông Tin',
      pageCount: 300,
      viewCount: 3200,
      downloadCount: 870,
      likesCount: 120,
      commentsCount: 35,
      rating: 4.9,
      createdAt: '2025-03-15',
      fileType: 'PDF',
    ),
  ];
  /// Fake profile data
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

  );
  @override
  Future<ProfileEntity> getProfile(int userId) async {
    // giả lập delay gọi API
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

    // giả lập upload thành công → trả URL mới
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
    );
  }
  @override
  List<DocumentModel> getDocumentsByUser(String id) {
    return _mockDocuments;}
}

