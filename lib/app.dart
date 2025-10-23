import 'package:flutter/material.dart';

import 'features/profile/presentation/profile_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StudyDocs',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      // màn hình đầu tiên khi mở app
      initialRoute: '/',

      routes: {
        '/': (context) => const HomePage(),
        '/profile': (context) {
          // Giả sử ta truyền userId = 1
          return const ProfilePage(userId: 1);
        },
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("StudyDocs Home")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Điều hướng sang ProfilePage
            Navigator.pushNamed(context, '/profile');
          },
          child: const Text("Đi tới Profile"),
        ),
      ),
    );
  }
}
