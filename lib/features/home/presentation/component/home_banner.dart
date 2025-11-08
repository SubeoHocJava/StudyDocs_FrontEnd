import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class HomeBanner extends StatelessWidget {
  final String? backgroundImageUrl;
  final String? backgroundImageAsset;
  final VoidCallback? onSearchTap;
  final ValueChanged<String>? onSearchChanged;
  final String? hintText;
  final double height;
  final double overlayOpacity;

  const HomeBanner({
    super.key,
    this.backgroundImageUrl,
    this.backgroundImageAsset,
    this.onSearchTap,
    this.onSearchChanged,
    this.hintText = 'Tìm kiếm tài liệu...',
    this.height = 200,
    this.overlayOpacity = 0.5,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary,
      ),
      child: Stack(
        children: [
          // Hình nền
          if (backgroundImageUrl != null || backgroundImageAsset != null)
            Positioned.fill(
              child: backgroundImageAsset != null
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
            child: Container(
              color: Colors.black.withOpacity(overlayOpacity),
            ),
          ),

          // Thanh tìm kiếm
          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                onTap: onSearchTap != null ? () => onSearchTap!() : null,
                onChanged: onSearchChanged,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyle(
                    color: AppColors.gray,
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppColors.gray,
                    size: 24,
                  ),
                  suffixIcon: Icon(
                    Icons.mic,
                    color: AppColors.primary,
                    size: 24,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 14,
                ),
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
          colors: [
            AppColors.primary,
            AppColors.secondaryBlue,
          ],
        ),
      ),
    );
  }
}



