import 'package:flutter/material.dart';
import 'package:studydocs/core/constants/app_colors.dart';

class ExploreHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData? subtitleIcon;

  const ExploreHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.subtitleIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              if (subtitleIcon != null) ...[
                Icon(
                  subtitleIcon,
                  color: AppColors.grey[700],
                  size: 20,
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.grey[700],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
