import 'package:flutter/material.dart';
import '../../../../core/widgets/layout/header/presentation/header.dart';
import '../../../../core/constants/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.white,
      appBar: Header(isDefault: true),
      body: Center(
        child: Text(
          'Trang chủ StudyDocs\n(Trống - Chưa có chức năng)',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
    );
  }
}
