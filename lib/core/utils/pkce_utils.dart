import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

class PkcePair {
  final String codeVerifier;
  final String codeChallenge;

  const PkcePair({
    required this.codeVerifier,
    required this.codeChallenge,
  });
}

class PkceUtils {
  PkceUtils._();

  static PkcePair generate() {
    final verifier = _createCodeVerifier();
    return PkcePair(
      codeVerifier: verifier,
      codeChallenge: _challengeS256(verifier),
    );
  }

  static String _createCodeVerifier() {
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~';
    final random = Random.secure();
    return List.generate(64, (_) => chars[random.nextInt(chars.length)]).join();
  }

  static String _challengeS256(String verifier) {
    final digest = sha256.convert(utf8.encode(verifier));
    return base64Url.encode(digest.bytes).replaceAll('=', '');
  }
}
