class RegisterRequest {
  final String username;
  final String? email;
  final String password;

  RegisterRequest({
    required this.username,
    this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        if (email != null && email!.isNotEmpty) 'email': email,
        'password': password,
      };

  factory RegisterRequest.fromJson(Map<String, dynamic> json) {
    return RegisterRequest(
      username: json['username'] ?? '',
      email: json['email'],
      password: json['password'] ?? '',
    );
  }
}