
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/widgets/feat/follow/logic/follow_bloc.dart';
import 'core/widgets/feat/follow/logic/follow_event.dart';
import 'core/widgets/feat/follow/presentation/follow_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (_) => FollowBloc()..add(LoadFollowDataEvent()),
        child: const Scaffold(
          body: Follow(),
        ),
      ),
    );
  }
}