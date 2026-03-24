import 'package:flutter/material.dart';
import 'core/feat/notification/presentation/demo/notification_notice_demo.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NotificationNoticeDemo(),
    );
  }
}