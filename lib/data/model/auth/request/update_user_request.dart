class UpdateUserRequest {
  final String? id;
  final String? username;
  final String? fullName;
  final String? email;
  final String? phoneNumber;
  final String? gender;
  final DateTime? dateOfBirth;
  final String? address;
  final String? avatarUrl;
  final String?school;

  UpdateUserRequest({
    this.id,
    this.username,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.gender,
    this.dateOfBirth,
    this.address,
    this.avatarUrl, this.school,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    
    if (id != null) data['id'] = id;
    if (username != null) data['username'] = username;
    if (fullName != null) data['fullName'] = fullName;
    if (email != null) data['email'] = email;
    if (phoneNumber != null) data['phoneNumber'] = phoneNumber;
    if (gender != null) data['gender'] = gender;
    if (dateOfBirth != null) data['dateOfBirth'] = dateOfBirth!.toIso8601String();
    if (address != null) data['address'] = address;
    if (avatarUrl != null) data['avatarUrl'] = avatarUrl;
    if (school != null) data['school'] = school;
    
    return data;
  }

  factory UpdateUserRequest.fromJson(Map<String, dynamic> json) {
    return UpdateUserRequest(
      id: json['id'],
      username: json['username'],
      fullName: json['fullName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      gender: json['gender'],
      dateOfBirth: json['dateOfBirth'] != null 
          ? DateTime.parse(json['dateOfBirth']) 
          : null,
      address: json['address'],
      avatarUrl: json['avatarUrl'],
      school: json['school'],
    );
  }
}
