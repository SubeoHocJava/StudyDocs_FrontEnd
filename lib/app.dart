import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studydocs/features/library/presentation/screen/library_screen.dart';
import 'package:studydocs/features/profile/presentation/screen/profile_screen.dart';
import 'package:studydocs/features/upload_file/presentation/screen/upload_file_screen.dart';



import 'core/theme/app_theme.dart';
import 'features/subject_library/presentation/screen/subject_library_screen.dart';


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

            // màn hình đầu tiên khi mở app
            home: UploadFileScreen()
            // BlocProvider(
            //   create: (context) => createHomeBloc(),
            //   child: const HomePage(),

          );
        },
      ),
    );
  }
}
