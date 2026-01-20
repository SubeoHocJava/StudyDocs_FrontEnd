import 'package:flutter/material.dart';
import 'package:studydocs/core/constants/app_colors.dart';
import 'package:studydocs/core/utils/responsive_helper.dart';
import 'package:studydocs/features/subject_library/domain/entity/subject_entity.dart';

class SubjectCategories extends StatelessWidget {
  final List<SubjectEntity> categories;
  final Function(int index)? onSubjectTap;
  
  const SubjectCategories(
    this.categories, {
    super.key,
    this.onSubjectTap,
  });

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
              child: Center(
                child: MonoSubject(
                  name: categories[index].name,
                  onTap: () => onSubjectTap?.call(index),
                ),
              )
            );
          },
        ),
      ],
    );
  }
}

class MonoSubject extends StatelessWidget {
  final String name;
  final VoidCallback? onTap;
  
  const MonoSubject({
    super.key,
    required this.name,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: responsive.widthPercent(responsive.isMobile ? 85 : 80),
        padding: EdgeInsets.all(responsive.isMobile ? 10 : 12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Theme.of(context).dividerColor,
          ),
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
            Icon(Icons.chevron_right, size: responsive.fontSize(18)),
          ],
        ),
      ),
    );
  }
}
