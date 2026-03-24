import 'package:flutter/cupertino.dart';

class AppRoute {
  final String path;
  final Widget screen;
  final List<AppRoute> children;
  final bool requireAuth;
  final bool requireAdmin;
  final GlobalKey<NavigatorState>? parentKey;

  AppRoute({
    required this.path,
    required this.screen,
    this.children = const [],
    this.requireAuth = false,
    this.requireAdmin = false,
    this.parentKey,
  });
}