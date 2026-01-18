import 'package:flutter/material.dart';
import 'package:studydocs/core/constants/app_colors.dart';
import 'package:studydocs/core/utils/responsive_helper.dart';
import 'package:studydocs/features/subject_library/domain/entity/subject_entity.dart';
import 'package:go_router/go_router.dart';

/// Widget hiển thị top 5 môn học phổ biến
/// Lấy data từ AcademicRemoteDataSourceImpl
class TopSubjects extends StatelessWidget {
  final List<SubjectEntity> subjects;
  final String schoolId;
  final String schoolName;

  const TopSubjects({
    super.key,
    required this.subjects,
    required this.schoolId,
    required this.schoolName,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    // Lấy top 5 hoặc ít hơn nếu không đủ
    final displaySubjects = subjects.take(5).toList();

    if (displaySubjects.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: responsive.defaultPadding,
          child: Text(
            'Môn học phổ biến',
            style: TextStyle(
              fontSize: responsive.fontSize(18),
              fontWeight: FontWeight.bold,
              color: AppColors.headerForeground,
            ),
          ),
        ),
        SizedBox(height: responsive.heightPercent(1)),
        SizedBox(
          height: responsive.heightPercent(12),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(
              horizontal: responsive.widthPercent(4),
            ),
            itemCount: displaySubjects.length,
            itemBuilder: (context, index) {
              final subject = displaySubjects[index];
              return _SubjectCard(
                subject: subject,
                schoolId: schoolId,
                schoolName: schoolName,
                responsive: responsive,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SubjectCard extends StatelessWidget {
  final SubjectEntity subject;
  final String schoolId;
  final String schoolName;
  final ResponsiveHelper responsive;

  const _SubjectCard({
    required this.subject,
    required this.schoolId,
    required this.schoolName,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to subject documents screen
        context.go(
          '/school/$schoolId/subject/${subject.id}?schoolName=${Uri.encodeComponent(schoolName)}&subjectName=${Uri.encodeComponent(subject.name)}',
        );
      },
      child: Container(
        width: responsive.widthPercent(40),
        margin: EdgeInsets.only(right: responsive.widthPercent(3)),
        padding: EdgeInsets.all(responsive.widthPercent(4)),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary.withOpacity(0.8),
              AppColors.secondaryTeal.withOpacity(0.6),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.book,
              color: Colors.white,
              size: responsive.fontSize(32),
            ),
            SizedBox(height: responsive.heightPercent(1)),
            Text(
              subject.name,
              style: TextStyle(
                fontSize: responsive.fontSize(14),
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
