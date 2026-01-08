import 'dart:async';

import 'package:studydocs/data/model/user.dart';
import '../manage_user_repository.dart';

class ManageUserRepositoryImpl extends ManageUserRepository {

  final List<UserModel> _mockUser = [
    UserModel(
      id: '1',
      fullName: 'Nguyễn Văn An',
      username: 'an.nguyen',
      email: 'an.nguyen@gmail.com',
      phoneNumber: '0901234567',
      avatarUrl: 'https://i.pravatar.cc/150?img=1',
      gender: 'male',
      dateOfBirth: DateTime(1998, 3, 12),
      address: 'Hà Nội',
    ),
    UserModel(
      id: '2',
      fullName: 'Trần Thị Bình',
      username: 'binh.tran',
      email: 'binh.tran@gmail.com',
      phoneNumber: '0902345678',
      avatarUrl: 'https://i.pravatar.cc/150?img=2',
      gender: 'female',
      dateOfBirth: DateTime(1999, 7, 22),
      address: 'TP. Hồ Chí Minh',
    ),
    UserModel(
      id: '3',
      fullName: 'Lê Quốc Cường',
      username: 'cuong.le',
      email: 'cuong.le@gmail.com',
      phoneNumber: '0903456789',
      avatarUrl: 'https://i.pravatar.cc/150?img=3',
      gender: 'male',
      dateOfBirth: DateTime(1997, 11, 5),
      address: 'Đà Nẵng',
    ),
    UserModel(
      id: '4',
      fullName: 'Phạm Thu Dung',
      username: 'dung.pham',
      email: 'dung.pham@gmail.com',
      phoneNumber: '0904567890',
      avatarUrl: 'https://i.pravatar.cc/150?img=4',
      gender: 'female',
      dateOfBirth: DateTime(2000, 1, 18),
      address: 'Cần Thơ',
    ),
    UserModel(
      id: '5',
      fullName: 'Hoàng Minh Đức',
      username: 'duc.hoang',
      email: 'duc.hoang@gmail.com',
      phoneNumber: '0905678901',
      avatarUrl: 'https://i.pravatar.cc/150?img=5',
      gender: 'male',
      dateOfBirth: DateTime(1996, 9, 30),
      address: 'Hải Phòng',
    ),
    UserModel(
      id: '6',
      fullName: 'Võ Thị Hạnh',
      username: 'hanh.vo',
      email: 'hanh.vo@gmail.com',
      phoneNumber: '0906789012',
      avatarUrl: 'https://i.pravatar.cc/150?img=6',
      gender: 'female',
      dateOfBirth: DateTime(1998, 5, 14),
      address: 'Quảng Ninh',
    ),
    UserModel(
      id: '7',
      fullName: 'Đặng Nhật Huy',
      username: 'huy.dang',
      email: 'huy.dang@gmail.com',
      phoneNumber: '0907890123',
      avatarUrl: 'https://i.pravatar.cc/150?img=7',
      gender: 'male',
      dateOfBirth: DateTime(1995, 12, 2),
      address: 'Bình Dương',
    ),
    UserModel(
      id: '8',
      fullName: 'Bùi Thảo Linh',
      username: 'linh.bui',
      email: 'linh.bui@gmail.com',
      phoneNumber: '0908901234',
      avatarUrl: 'https://i.pravatar.cc/150?img=8',
      gender: 'female',
      dateOfBirth: DateTime(2001, 8, 9),
      address: 'Nam Định',
    ),
    UserModel(
      id: '9',
      fullName: 'Phan Công Minh',
      username: 'minh.phan',
      email: 'minh.phan@gmail.com',
      phoneNumber: '0909012345',
      avatarUrl: 'https://i.pravatar.cc/150?img=9',
      gender: 'male',
      dateOfBirth: DateTime(1997, 4, 27),
      address: 'Nghệ An',
    ),
    UserModel(
      id: '10',
      fullName: 'Đỗ Thị Ngọc',
      username: 'ngoc.do',
      email: 'ngoc.do@gmail.com',
      phoneNumber: '0910123456',
      avatarUrl: 'https://i.pravatar.cc/150?img=10',
      gender: 'female',
      dateOfBirth: DateTime(1999, 10, 16),
      address: 'Huế',
    ),
  ];


  // =============================
  // Add user (theo userID)
  // =============================
  @override
  Future<bool> addUser(String userID) async {
    // kiểm tra trùng ID
    final exists = _mockUser.any((u) => u.id == userID);
    if (exists) return false;

    // mock dữ liệu user
    final newUser = UserModel(
      id: userID,
      fullName: 'User $userID',
      username: 'user_$userID',
      email: 'user_$userID@email.com',
      phoneNumber: '0123456789',
      avatarUrl: '',
      gender: 'unknown',
      dateOfBirth: null,
      address: '',
    );

    _mockUser.add(newUser);
    return true;
  }

  // =============================
  // Delete user
  // =============================
  @override
  Future<bool> deleteUser(String userID) async {
    final index = _mockUser.indexWhere((u) => u.id == userID);
    if (index == -1) return false;

    _mockUser.removeAt(index);
    return true;
  }

  // =============================
  // Edit user
  // =============================
  @override
  Future<bool> editUser(UserModel user) async {
    final index = _mockUser.indexWhere((u) => u.id == user.id);
    if (index == -1) return false;

    _mockUser[index] = user;
    return true;
  }

  // =============================
  // Find user by username + paging
  // =============================
  @override
  Future<List<UserModel>> findUserPage(
      int frompage,
      int topage,
      String username,
      ) async {
    final filtered = _mockUser.where((u) =>
        u.fullName.toLowerCase().contains(username.toLowerCase())
    ).toList();

    // if (frompage >= filtered.length) return [];

    // final end = topage > filtered.length ? filtered.length : topage;
    // return filtered.sublist(frompage, end);
    print(username);
    print(filtered.isEmpty);
    return filtered;
  }

  // =============================
  // Get user list by page
  // =============================
  @override
  Future<List<UserModel>> getListUserPage(
      int frompage,
      int topage,
      int numUser,
      ) async {
    // final startIndex = frompage * numUser;
    // final endIndex = startIndex + numUser;
    //
    // if (startIndex >= _mockUser.length) return [];
    //
    // final end = endIndex > _mockUser.length
    //     ? _mockUser.length
    //     : endIndex;

    // return _mockUser.sublist(startIndex, end);
    return _mockUser;
  }
}
