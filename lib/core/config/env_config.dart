import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  /// Ví dụ: `http://localhost:8090/api/v1` (không slash cuối cũng được).
  static String get apiBaseUrl {
    final raw =
        dotenv.env['API_BASE_URL']?.trim() ??
        'http://localhost:8080';
    final normalized = raw.replaceAll(RegExp(r'/+$'), '');
    return '$normalized/';
  }

  static String get googleRedirectUri =>
      dotenv.env['GOOGLE_REDIRECT_URI']?.trim() ?? 'studydocs://callback';

  static String? get googleWebClientId =>
      dotenv.env['GOOGLE_WEB_CLIENT_ID']?.trim();

  static String? get googleClientId =>
      dotenv.env['GOOGLE_CLIENT_ID']?.trim();
}
