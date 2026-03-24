import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app_route_model.dart';

final List<AppRoute> appRoutes = [
  // AppRoute(path: '/home', screen: MainTabHomePage()),
  // AppRoute(path: '/lib', screen: LibPage()), Đây là demo
];
// Ví dụ cho 2 trang home và lib demo
// class MainTabHomePage extends StatelessWidget{
//   @override
//   Widget build(BuildContext context) {
//    return Scaffold(
//      body: Column(children: [Text("Đây là trang home"),ElevatedButton(onPressed: () => context.go('/lib'), child: Text("đến trang lib"))],
//      ),
//    );
//   }
// }
// class LibPage extends StatelessWidget{
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(children: [Text("Đây là trang lib")],),
//     );
//   }
// }