import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:studydocs/features/user/profile/presentation/ProfileScreen.dart';
import 'package:studydocs/features/user/user_follow/presentation/screen/user_follow_screen.dart';

import 'app_route_model.dart';
final List<AppRoute> appRoutes = [
  AppRoute(path: '/home', screen: ProfileScreen()),
  AppRoute(path: '/followers', screen: const UserFollowScreen(initialTab: 0)),
  AppRoute(path: '/following', screen: const UserFollowScreen(initialTab: 1)),
];
