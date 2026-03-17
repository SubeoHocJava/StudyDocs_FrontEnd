import 'package:flutter/material.dart';
import 'package:studydocs/core/feat/notification/presentation/demo/notification_detail_demo.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NotificationDetailDemo(),
    );
  }
}