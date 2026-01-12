class RegisterRequest {
  final String username;
  final String? email;
  final String password;
  final String? displayName;

  RegisterRequest({
    required this.username,
    this.email,
    required this.password,
    this.displayName,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        if (email != null && email!.isNotEmpty) 'email': email,
        'password': password,
        if (displayName != null) 'displayName': displayName,
      };

  factory RegisterRequest.fromJson(Map<String, dynamic> json) {
    return RegisterRequest(
      username: json['username'] ?? '',
      email: json['email'],
      password: json['password'] ?? '',
      displayName: json['displayName'],
    );
  }
}