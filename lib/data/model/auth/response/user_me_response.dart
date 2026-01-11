/// Model để parse response từ GET /api/user/me
class UserMeResponse {
  final String id;
  final String email;
  final String username;
  final String displayName;
  final bool isActive;
  final bool emailVerified;
  final String createdAt;
  final List<String> roles;
  final List<String> permissions;
  final String provider;

  UserMeResponse({
    required this.id,
    required this.email,
    required this.username,
    required this.displayName,
    required this.isActive,
    required this.emailVerified,
    required this.createdAt,
    required this.roles,
    required this.permissions,
    required this.provider,
  });

  /// Parse từ JSON response
  factory UserMeResponse.fromJson(Map<String, dynamic> json) {
    return UserMeResponse(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      displayName: json['displayName'] ?? '',
      isActive: json['isActive'] ?? false,
      emailVerified: json['emailVerified'] ?? false,
      createdAt: json['createdAt'] ?? '',
      roles: List<String>.from(json['roles'] ?? []),
      permissions: List<String>.from(json['permissions'] ?? []),
      provider: json['provider'] ?? 'local',
    );
  }

  /// Check nếu user có role admin
  bool get isAdmin => roles.contains('ROLE_ADMIN');

  /// Get first role hoặc default
  String get primaryRole => roles.isNotEmpty ? roles.first : 'ROLE_USER';

  @override
  String toString() {
    return 'UserMeResponse(id: $id, username: $username, roles: $roles, isAdmin: $isAdmin)';
  }
}
