import 'package:go_router/go_router.dart';
import 'package:studydocs/core/router/route_security.dart';
import 'app_route_model.dart';
import 'app_routes_list.dart';

GoRouter initAppRouter() {
  return GoRouter(
    initialLocation: '/home',
    routes: appRoutes.map(buildRoute).toList(),
  );
}

GoRoute buildRoute(AppRoute r) {
  return GoRoute(
    path: r.path,
    redirect: (context, state) {
      if (r.requireAdmin) return adminGuard(context, state);
      if (r.requireAuth) return authGuard(context, state);
      return null;
    },
    builder: (context, state) => r.screen,
  );
}