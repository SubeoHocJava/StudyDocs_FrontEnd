class AuthTokenDto {
  final String accessToken;
  final String refreshToken;
  final int? expiresIn;
  final String tokenType;

  const AuthTokenDto({
    required this.accessToken,
    required this.refreshToken,
    this.expiresIn,
    this.tokenType = 'Bearer',
  });

  factory AuthTokenDto.fromJson(Map<String, dynamic> json) {
    return AuthTokenDto(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String? ?? '',
      expiresIn: json['expiresIn'] as int?,
      tokenType: json['tokenType'] as String? ?? 'Bearer',
    );
  }
}

class GoogleAuthUrlDto {
  final String authorizationUrl;

  const GoogleAuthUrlDto({required this.authorizationUrl});

  factory GoogleAuthUrlDto.fromJson(Map<String, dynamic> json) {
    return GoogleAuthUrlDto(
      authorizationUrl:
          json['authorizationUrl'] as String? ??
          json['authorization_url'] as String? ??
          '',
    );
  }
}
