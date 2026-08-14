import 'package:flutter/material.dart';
import 'package:studydocs/core/constants/app_colors.dart';

class ExploreSearchBar extends StatelessWidget {
  final String hintText;
  final VoidCallback onTap;

  const ExploreSearchBar({
    super.key,
    required this.hintText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  hintText,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.search,
                color: AppColors.primary, // Using primary color for search icon as in image
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
