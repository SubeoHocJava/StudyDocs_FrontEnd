/// Model cho token data trả về từ API login
class TokenData {
  final String accessToken;
  final String refreshToken;
  final String tokenType;

  TokenData({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
  });

  factory TokenData.fromJson(Map<String, dynamic> json) => TokenData(
        accessToken: json['accessToken'] ?? '',
        refreshToken: json['refreshToken'] ?? '',
        tokenType: json['tokenType'] ?? 'Bearer',
      );

  Map<String, dynamic> toJson() => {
        'accessToken': accessToken,
        'refreshToken': refreshToken,
        'tokenType': tokenType,
      };
}

