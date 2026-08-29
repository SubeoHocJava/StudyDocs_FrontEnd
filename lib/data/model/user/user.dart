class User {
  String? id;

  String? fullName;
  String? username;
  String? email;
  String? phoneNumber;
  String? avatarUrl;
  String? gender;
  DateTime? dateOfBirth;
  String? address;
  String? school;

  bool isPrivate;

  int followersCount;
  int followingCount;
  int likesCount;
  int postsCount;
  int commentsCount;

  User({
    this.id,
    this.fullName,
    this.username,
    this.email,
    this.phoneNumber,
    this.avatarUrl,
    this.gender,
    this.dateOfBirth,
    this.address,
    this.school,
    this.isPrivate = false,
    this.followersCount = 0,
    this.followingCount = 0,
    this.likesCount = 0,
    this.postsCount = 0,
    this.commentsCount = 0,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullName: json['fullName'],
      username: json['username'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      avatarUrl: json['avatarUrl'],
      gender: json['gender'],
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'])
          : null,
      address: json['address'],
      school: json['school'],
      isPrivate: json['isPrivate'] ?? false,
      followersCount: json['followersCount'] ?? 0,
      followingCount: json['followingCount'] ?? 0,
      likesCount: json['likesCount'] ?? 0,
      postsCount: json['postsCount'] ?? 0,
      commentsCount: json['commentsCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'username': username,
      'email': email,
      'phoneNumber': phoneNumber,
      'avatarUrl': avatarUrl,
      'gender': gender,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'address': address,
      'school': school,
      'isPrivate': isPrivate,
      'followersCount': followersCount,
      'followingCount': followingCount,
      'likesCount': likesCount,
      'postsCount': postsCount,
      'commentsCount': commentsCount,
    };
  }
}

