import 'dart:async';

class Profile {
  final String userName;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String? gender;
  final DateTime? birthDate;
  final String address;

  Profile({
    required this.userName,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    this.gender,
    this.birthDate,
    required this.address,
  });

  /// từ Map (API) sang Profile
  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      userName: map['userName'] ?? '',
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      gender: map['gender'],
      birthDate: map['birthDate'] != null
          ? DateTime.tryParse(map['birthDate'])
          : null,
      address: map['address'] ?? '',
    );
  }

  /// từ Profile sang Map (nếu cần gửi API)
  Map<String, dynamic> toMap() {
    return {
      "userName": userName,
      "fullName": fullName,
      "email": email,
      "phoneNumber": phoneNumber,
      "gender": gender,
      "birthDate": birthDate?.toIso8601String(),
      "address": address,
    };
  }
}

class ProfileRepository {
  /// Lấy profile từ server / giả lập API
  Future<Profile> getProfile(int userId) async {
    await Future.delayed(const Duration(seconds: 1));

    // Giả lập dữ liệu từ API
    final data = {
      "userName": "vana$userId",
      "fullName": "Nguyễn Văn A",
      "email": "vana$userId@example.com",
      "phoneNumber": "0123456789",
      "gender": "Male",
      "birthDate": "1990-01-01",
      "address": "Hà Nội",
    };

    return Profile.fromMap(data);
  }

  /// Cập nhật profile
  Future<Profile> updateProfile(Map<String, dynamic> data) async {
    await Future.delayed(const Duration(seconds: 1));

    // Ở đây giả lập API trả về chính data vừa gửi
    return Profile.fromMap(data);
  }
}
