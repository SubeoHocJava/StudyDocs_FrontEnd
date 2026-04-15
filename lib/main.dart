import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app.dart';
import 'core/router/app_router.dart';


void main() async {
  final router = initAppRouter();
  runApp(MyApp(router: router),
  );

}
