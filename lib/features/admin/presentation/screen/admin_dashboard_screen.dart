import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:studydocs/core/router/app_router.dart';
import 'package:studydocs/core/constants/app_icons.dart';
import 'package:studydocs/core/widgets/upload_box.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Color(0xFF1A237E),
                    ),
                    onPressed: () => context.pop(),
                  ),
                  const Text(
                    'Admin',
                    style: TextStyle(
                      color: Color(0xFF1A237E),
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Column
                  Expanded(
                    child: Column(
                      children: [
                        _AdminCard(
                          color: const Color(0xFFE8EAF6),
                          icon: Image.asset(AppAssets.logo, height: 80),
                          label: '',
                          height: 140,
                        ),
                        const SizedBox(height: 20),
                        _AdminCard(
                          color: const Color(0xFFC5CAE9),
                          icon: const Icon(
                            Icons.description,
                            size: 60,
                            color: Color(0xFF4FC3F7),
                          ),
                          label: 'Quản lý\ntài liệu',
                          height: 220,
                          onTap: () => context.push(AppRoutes.docsManagement),
                        ),
                        const SizedBox(height: 20),
                        _AdminCard(
                          color: const Color(0xFF7986CB),
                          icon: const Icon(
                            Icons.bar_chart,
                            size: 60,
                            color: Color(0xFF1A237E),
                          ),
                          label: 'Thống kê',
                          height: 220,
                          onTap: () => context.push(AppRoutes.statistic),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  // Right Column
                  Expanded(
                    child: Column(
                      children: [
                        _AdminCard(
                          color: const Color(0xFF00E5FF),
                          icon: const Icon(
                            Icons.group,
                            size: 60,
                            color: Color(0xFF1A237E),
                          ),
                          label: 'Quản lý\nngười dùng',
                          height: 220,
                          onTap: () => context.push(AppRoutes.manageUser),
                        ),
                        const SizedBox(height: 20),
                        _AdminCard(
                          color: const Color(0xFF81C784),
                          icon: const Icon(
                            Icons.home_work,
                            size: 60,
                            color: Color(0xFF1A237E),
                          ),
                          label: 'Mẫu\nthông báo',
                          height: 220,
                          onTap:
                              () =>
                                  context.push(AppRoutes.notificationTemplates),
                        ),
                        const SizedBox(height: 20),
                        const UploadBox(),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AdminCard extends StatelessWidget {
  final Color color;
  final Widget icon;
  final String label;
  final double height;
  final VoidCallback? onTap;
  final double fontSize;

  const _AdminCard({
    required this.color,
    required this.icon,
    required this.label,
    required this.height,
    this.onTap,
    this.fontSize = 18,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              if (label.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF1A237E),
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
