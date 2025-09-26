import 'package:flutter/material.dart';
import 'package:studydocs/screens/library_screen.dart';
import 'package:studydocs/screens/subject_library_screen.dart';
import 'package:studydocs/screens/upload_file_screen.dart';
import 'app.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(const MyApp());
// }
void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UploadFileScreen(),
    ),
  );
}
