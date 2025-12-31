import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Demo-only screen: hiển thị thông tin lấy được từ Google `idToken` (JWT).
///
/// Mục đích:
/// - Cho thấy app đã Google Sign-In thành công
/// - Hiển thị các claim phổ biến: email/name/picture
/// - Hiển thị "đã lấy được idToken" (độ dài token)
///
/// Có thể xoá màn này về sau mà không ảnh hưởng kiến trúc:
/// - Xoá file này
/// - Xoá đoạn navigate trong `LoginModal` khi `LoginSuccess`
class GoogleDebugScreen extends StatelessWidget {
  final String idToken;

  const GoogleDebugScreen({super.key, required this.idToken});

  Map<String, dynamic>? _tryDecodeJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) return null;

    try {
      final normalized = base64Url.normalize(parts[1]);
      final jsonStr = utf8.decode(base64Url.decode(normalized));
      final decoded = jsonDecode(jsonStr);
      if (decoded is Map<String, dynamic>) return decoded;
      return null;
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {



    final claims = _tryDecodeJwt(idToken) ?? const <String, dynamic>{};

    final email = (claims['email'] ?? '').toString();
    final name = (claims['name'] ?? '').toString();
    final picture = (claims['picture'] ?? '').toString();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Login Demo'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Avatar
          Center(
            child: CircleAvatar(
              radius: 44,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: picture.isNotEmpty ? NetworkImage(picture) : null,
              child: picture.isEmpty
                  ? const Icon(Icons.person, size: 44, color: Colors.grey)
                  : null,
            ),
          ),
          const SizedBox(height: 16),

          _InfoTile(label: 'Name', value: name.isEmpty ? '(empty)' : name),
          _InfoTile(label: 'Email', value: email.isEmpty ? '(empty)' : email),
          _InfoTile(label: 'idToken', value: 'OK (len=${idToken.length})'),
          _InfoTile(label: 'idToken', value: 'OK (len=${idToken.length})'),
          const SizedBox(height: 12),

          // Nút copy idToken
          FilledButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: idToken));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã copy idToken')),
              );
            },
            child: const Text('Copy idToken'),
          ),
          const SizedBox(height: 12),

          // Hiển thị token để copy thủ công (nếu cần)
          SelectableText(
            idToken,
            style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
          ),
          const SizedBox(height: 12),
          const SizedBox(height: 12),

          // Raw claims (để demo thấy "lấy được những gì")
          ExpansionTile(
            title: const Text('JWT Claims (decoded)'),
            subtitle: const Text('Các field có thể khác tuỳ tài khoản/scope'),
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  // `withOpacity` deprecated → dùng withValues để tránh precision loss.
                  color: Colors.black.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  const JsonEncoder.withIndent('  ').convert(claims),
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
          const SizedBox(height: 24),

          // Nút back rõ ràng để demo
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Back'),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;

  const _InfoTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 72,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(height: 1.3),
            ),
          ),
        ],
      ),
    );
  }
}

