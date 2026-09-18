// route_guards.dart

import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:studydocs/core/network/token_services.dart';

FutureOr<String?> authGuard(BuildContext context, GoRouterState state) async {
  final hasToken = await TokenStorageService().hasToken();
  if (!hasToken) {
    // Redirect to home if not authenticated
    return '/home';
  }
  return null;
}

FutureOr<String?> adminGuard(BuildContext context, GoRouterState state) async {
  final isAdmin = await TokenStorageService().isAdmin();
  if (!isAdmin) {
    return '/home';
  }
  return null;
}
