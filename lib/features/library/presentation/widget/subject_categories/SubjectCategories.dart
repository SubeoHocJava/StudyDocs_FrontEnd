import 'package:flutter/material.dart';
import 'package:studydocs/core/constants/app_colors.dart';
import 'package:studydocs/core/utils/responsive_helper.dart';

class SubjectCategories extends StatelessWidget {
  final List<String> categories;
  const SubjectCategories(this.categories, {super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.widthPercent(4),
            vertical: responsive.heightPercent(1),
          ),
          child: Text(
            "Môn học",
            style: TextStyle(
              fontSize: responsive.fontSize(18),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(
                vertical: responsive.heightPercent(0.5),
              ),
              child: MonoSubject(name: categories[index]),
            );
          },
        ),
      ],
    );
  }
}

class MonoSubject extends StatelessWidget {
  final String name;
  const MonoSubject({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Container(
      width: responsive.widthPercent(responsive.isMobile ? 80 : 40),
      padding: EdgeInsets.all(responsive.isMobile ? 8 : 12),
      decoration: BoxDecoration(
        color: AppColors.headerBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.headerBackground),
      ),
      child: Row(
        children: [
          Icon(Icons.folder, size: responsive.fontSize(18)),
          SizedBox(width: responsive.widthPercent(2)),
          Expanded(
            child: Text(
              name,
              style: TextStyle(fontSize: responsive.fontSize(14)),
            ),
          ),
        ],
      ),
    );
  }
}
