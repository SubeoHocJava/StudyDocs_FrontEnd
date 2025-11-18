import 'package:flutter/material.dart';
import 'package:studydocs/features/library/presentation/screen/library_screen.dart';
import 'package:studydocs/features/profile/presentation/screen/profile_screen.dart';
import 'package:studydocs/features/subject_library/presentation/screen/subject_library_screen.dart';
import 'package:studydocs/features/upload_file/presentation/screen/upload_file_screen.dart';
import 'app.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(const MyApp());
// }
void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ),
  );
}
