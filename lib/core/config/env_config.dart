import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:studydocs/core/constants/api/keycloak_api.dart';

class EnvConfig {
  static String get keycloakBaseUrl =>
      dotenv.env['KEYCLOAK_BASE_URL']?.trim() ?? '';

  static String get keycloakRealm =>
      dotenv.env['KEYCLOAK_REALM']?.trim() ?? '';

  static String get keycloakClientId =>
      dotenv.env['KEYCLOAK_CLIENT_ID']?.trim() ?? '';

  static String get keycloakClientSecret =>
      dotenv.env['KEYCLOAK_CLIENT_SECRET']?.trim() ?? '';

  static String get tokenEndpoint =>
      KeycloakApi.tokenUrl(keycloakBaseUrl, keycloakRealm);

  static String get logoutEndpoint =>
      KeycloakApi.logoutUrl(keycloakBaseUrl, keycloakRealm);

  static bool get isKeycloakConfigured =>
      keycloakBaseUrl.isNotEmpty &&
      keycloakRealm.isNotEmpty &&
      keycloakClientId.isNotEmpty;
}
