import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:studydocs/core/constants/app_colors.dart';

/// Widget avatar dùng chung — đồng nhất giao diện trên toàn app.
/// Tự động cache ảnh, có fallback icon khi url null hoặc lỗi load.
class UserAvatar extends StatelessWidget {
  final String? avatarUrl;
  final double radius;
  final Color? backgroundColor;
  final Color? iconColor;
  final double? iconSize;

  const UserAvatar({
    super.key,
    this.avatarUrl,
    this.radius = 22,
    this.backgroundColor,
    this.iconColor,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? AppColors.grey[200]!;
    final iSize = iconSize ?? radius * 0.9;
    final diameter = radius * 2;

    if (avatarUrl == null || avatarUrl!.isEmpty) {
      return _buildFallback(diameter, bgColor, iSize);
    }

    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: avatarUrl!,
        width: diameter,
        height: diameter,
        fit: BoxFit.cover,
        placeholder: (context, url) => _buildFallback(diameter, bgColor, iSize),
        errorWidget: (context, url, error) => _buildFallback(diameter, bgColor, iSize),
      ),
    );
  }

  Widget _buildFallback(double size, Color bgColor, double iSize) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.person,
        size: iSize,
        color: iconColor ?? AppColors.grey[500],
      ),
    );
  }
}
