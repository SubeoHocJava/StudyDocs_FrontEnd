import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:studydocs/core/router/route_security.dart';
import 'app_route_model.dart';
import 'app_routes_list.dart';
final rootNavigatorKey = GlobalKey<NavigatorState>();
GoRouter initAppRouter() {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/home',
    routes: appRoutes.map(buildRoute).toList(),
  );
}
void showGlobalDialog(Widget dialog) {
  final context = rootNavigatorKey.currentContext;
  if (context != null) {
    showDialog(
      context: context,
      builder: (_) => dialog,
    );
  }
}
GoRoute buildRoute(AppRoute r) {
  return GoRoute(
    path: r.path,
    parentNavigatorKey: r.parentKey,
    redirect: (context, state) {
      if (r.requireAdmin) return adminGuard(context, state);
      if (r.requireAuth) return authGuard(context, state);
      return null;
    },
    builder: (context, state) => r.screen,
  );
}