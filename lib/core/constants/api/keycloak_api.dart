/// Keycloak OpenID Connect path segments.
/// Full URL: `{KEYCLOAK_BASE_URL}/realms/{realm}/{segment}`
class KeycloakApi {
  KeycloakApi._();

  static const String openIdConnect = 'protocol/openid-connect';
  static const String token = '$openIdConnect/token';
  static const String logout = '$openIdConnect/logout';

  static String realmPrefix(String realm) => 'realms/$realm';

  static String tokenUrl(String baseUrl, String realm) {
    final base = baseUrl.replaceAll(RegExp(r'/+$'), '');
    return '$base/${realmPrefix(realm)}/$token';
  }

  static String logoutUrl(String baseUrl, String realm) {
    final base = baseUrl.replaceAll(RegExp(r'/+$'), '');
    return '$base/${realmPrefix(realm)}/$logout';
  }
}
