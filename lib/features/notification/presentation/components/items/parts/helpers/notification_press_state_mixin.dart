import 'package:flutter/material.dart';

mixin NotificationPressStateMixin<T extends StatefulWidget> on State<T> {
  bool _isPressed = false;

  void handlePressDown() => setState(() => _isPressed = true);
  void handlePressUp() => setState(() => _isPressed = false);
  void handlePressCancel() => setState(() => _isPressed = false);

  bool get isPressed => _isPressed;
}

