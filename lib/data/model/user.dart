class UserModel {
  final String id;
  final String fullName;
  final String username;
  final String email;
  final String phoneNumber;
  final String avatarUrl;
  final String gender;
  final DateTime? dateOfBirth;
  final String address;
  final String school;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.avatarUrl,
    required this.gender,
    this.dateOfBirth,
    required this.address,
    required this.school,
  });

  /// 🔹 Map từ JSON → Object
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
      gender: json['gender'] ?? '',
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'])
          : null,
      address: json['address'] ?? '', school: json['school']??'',
    );
  }

  /// 🔹 Map từ Object → JSON (khi gửi ngược lên server)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'username': username,
      'email': email,
      'phoneNumber': phoneNumber,
      'avatarUrl': avatarUrl,
      'gender': gender,
      'dateOfBirth': dateOfBirth?.toIso8601String().split('T').first,
      'address': address,
      'school':school,
    };
  }

  UserModel copyWith({
    String? id,
    String? fullName,
    String? username,
    String? email,
    String? phoneNumber,
    String? avatarUrl,
    String? gender,
    DateTime? dateOfBirth,
    String? address,
    String? school,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      address: address ?? this.address, school:school?? this.school,
    );
  }
}
