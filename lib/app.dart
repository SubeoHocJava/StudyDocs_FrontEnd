// lib/app.dart  ← SỬA CHỈ 1 DÒNG ĐỂ TEST DOCS
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'features/docs/logic/docs_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeController(),
      child: Consumer<ThemeController>(
        builder: (context, themeController, child) {
          return MaterialApp(
            title: 'StudyDocs',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeController.mode,

            // ← CHỈ SỬA DÒNG NÀY ĐỂ CHẠY DOCS NGAY
            home: const DocsPage(),   // Đổi thành DocsPage để test

            // Khi nào xong test, bạn lại đổi lại thành:
            // home: BlocProvider(
            //   create: (context) => createHomeBloc(),
            //   child: const HomePage(),
            // ),
          );
        },
      ),
    );
  }
}