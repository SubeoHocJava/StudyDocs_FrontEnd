class UserModel {
  final String id;
  final String username;
  final String? email;
  final List<String> roles;
  final List<String> permissions;
  final String? createdAt;
  final String? updatedAt;

  UserModel({
    required this.id,
    required this.username,
    this.email,
    this.roles = const [],
    this.permissions = const [],
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] ?? '',
        username: json['username'] ?? '',
        email: json['email'],
        roles: (json['roles'] as List?)?.map((e) => e.toString()).toList() ?? const [],
        permissions: (json['permissions'] as List?)?.map((e) => e.toString()).toList() ?? const [],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        if (email != null) 'email': email,
        'roles': roles,
        'permissions': permissions,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}

