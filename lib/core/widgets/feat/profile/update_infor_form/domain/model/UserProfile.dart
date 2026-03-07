class UserProfile {
  final String userName;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String address;
  final String? gender;
  final DateTime? birthDate;
  final String? school;

  UserProfile({
    required this.userName,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.address,
    this.gender,
    this.birthDate,
    this.school,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userName: json['userName'],
      fullName: json['fullName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      gender: json['gender'],
      birthDate: json['birthDate'] != null
          ? DateTime.parse(json['birthDate'])
          : null,
      school: json['school'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "userName": userName,
      "fullName": fullName,
      "email": email,
      "phoneNumber": phoneNumber,
      "address": address,
      "gender": gender,
      "birthDate": birthDate?.toIso8601String(),
      "school": school,
    };
  }
}
