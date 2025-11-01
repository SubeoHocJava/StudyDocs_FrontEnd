import 'package:flutter/material.dart';

/// Mixin quản lý trạng thái press của notification item
/// - Theo dõi và cập nhật trạng thái pressed
/// - Cung cấp các handlers cho các sự kiện touch
/// - Tự động cleanup state khi cancel/release
mixin NotificationPressStateMixin<T extends StatefulWidget> on State<T> {
  bool _isPressed = false;

  void handlePressDown() => setState(() => _isPressed = true);
  void handlePressUp() => setState(() => _isPressed = false);
  void handlePressCancel() => setState(() => _isPressed = false);

  bool get isPressed => _isPressed;
}

