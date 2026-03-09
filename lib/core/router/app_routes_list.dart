import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:studydocs/features/user/profile/presentation/ProfileScreen.dart';

import 'app_route_model.dart';
final List<AppRoute> appRoutes = [
  AppRoute(path: '/home', screen: ProfileScreen()),
];
