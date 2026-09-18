import 'dart:convert';

class JwtUtils {
  static Map<String, dynamic> decodePayload(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw FormatException('Invalid JWT');
    }

    var payload = parts[1].replaceAll('-', '+').replaceAll('_', '/');
    switch (payload.length % 4) {
      case 0:
        break;
      case 2:
        payload += '==';
        break;
      case 3:
        payload += '=';
        break;
      default:
        throw FormatException('Invalid base64 in JWT');
    }

    final decoded = utf8.decode(base64Url.decode(payload));
    final map = json.decode(decoded);
    if (map is! Map<String, dynamic>) {
      throw FormatException('Invalid JWT payload');
    }
    return map;
  }

  static List<String> extractRealmRoles(String accessToken) {
    try {
      final claims = decodePayload(accessToken);
      final realmAccess = claims['realm_access'];
      if (realmAccess is Map<String, dynamic>) {
        final roles = realmAccess['roles'];
        if (roles is List) {
          return roles.map((e) => e.toString()).toList();
        }
      }
    } catch (_) {}
    return [];
  }
}
