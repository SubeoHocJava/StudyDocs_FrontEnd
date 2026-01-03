import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class _OutlinedText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color fillColor;
  final Color strokeColor;
  final double strokeWidth;

  const _OutlinedText({
    required this.text,
    required this.fontSize,
    required this.fontWeight,
    required this.fillColor,
    required this.strokeColor,
    required this.strokeWidth,
  });

  @override
  Widget build(BuildContext context) {
    final baseStyle = TextStyle(
      fontFamily: 'Times New Roman',
      fontSize: fontSize,
      fontWeight: fontWeight,
    );

    return Stack(
      children: [
        Text(
          text,
          textAlign: TextAlign.center,
          style: baseStyle.copyWith(
            foreground:
                Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = strokeWidth
                  ..color = strokeColor,
          ),
        ),
        Text(
          text,
          textAlign: TextAlign.center,
          style: baseStyle.copyWith(color: fillColor),
        ),
      ],
    );
  }
}

class HomeBanner extends StatelessWidget {
  final String? backgroundImageUrl;
  final String? backgroundImageAsset;
  final VoidCallback? onSearchTap;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onMicTap;
  final TextEditingController? controller;
  final String? hintText;
  final double height;
  final double overlayOpacity;

  const HomeBanner({
    super.key,
    this.backgroundImageUrl,
    this.backgroundImageAsset,
    this.onSearchTap,
    this.onSearchChanged,
    this.onMicTap,
    this.controller,
    this.hintText = 'Tìm kiếm tài liệu...',
    this.height = 200,
    this.overlayOpacity = 0.5,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(color: AppColors.primary),
      child: Stack(
        children: [
          // Hình nền
          if (backgroundImageUrl != null || backgroundImageAsset != null)
            Positioned.fill(
              child:
                  backgroundImageAsset != null
                      ? Image.asset(
                        backgroundImageAsset!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildDefaultGradient();
                        },
                      )
                      : Image.network(
                        backgroundImageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildDefaultGradient();
                        },
                      ),
            )
          else
            // Gradient mặc định nếu không có hình ảnh
            _buildDefaultGradient(),

          // Lớp phủ màu đen
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(overlayOpacity)),
          ),

          Positioned(
            left: 16,
            right: 16,
            top: 32,
            child: Column(
              children: [
                const _OutlinedText(
                  text: 'StudyDocs',
                  fontSize: 42,
                  fontWeight: FontWeight.w700,
                  fillColor: Colors.white,
                  strokeColor: Color(0xFF0D1B6E),
                  strokeWidth: 4,
                ),
                const SizedBox(height: 2),
                const _OutlinedText(
                  text: 'Chia sẻ kiến thức - Học hỏi cùng nhau',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fillColor: Color(0xFFFFF8B0),
                  strokeColor: Color(0xFF000000),
                  strokeWidth: 3,
                ),
              ],
            ),
          ),

          // Thanh tìm kiếm
          Positioned(
            left: 16,
            right: 16,
            bottom: 18,
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: controller,
                onTap: onSearchTap != null ? () => onSearchTap!() : null,
                onChanged: onSearchChanged,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyle(
                    color: AppColors.gray.withOpacity(0.6),
                    fontSize: 13.5,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppColors.gray.withOpacity(0.7),
                    size: 20,
                  ),
                  suffixIcon: IconButton(
                    onPressed: onMicTap,
                    padding: EdgeInsets.zero,
                    icon: Icon(Icons.mic, color: AppColors.primary, size: 20),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                ),
                style: const TextStyle(fontSize: 13.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultGradient() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.secondaryBlue],
        ),
      ),
    );
  }
}
