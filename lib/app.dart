import 'package:flutter/material.dart';
import 'package:studydocs/features/library/presentation/screen/library_screen.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StudyDocs',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),

      // màn hình đầu tiên khi mở app
      initialRoute: '/',

      routes: {
        '/': (context) => const HomePage(),
        '/library': (context) => LibraryScreen(), // thêm LibraryScreen
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/profile');
              },
              child: const Text("Đi tới Profile"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/library');
              },
              child: const Text("Đi tới Library"),
            ),
          ],
        ),
      ),
    );
  }
}
