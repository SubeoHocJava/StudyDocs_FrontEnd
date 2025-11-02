import 'package:flutter/material.dart';
import 'package:studydocs/core/constants/app_colors.dart';
class SubjectCategories extends StatelessWidget {

  final List<String>categories;
  const SubjectCategories(this.categories, {super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;//screen size
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Môn học",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 4.0,
                horizontal: 16.0,
              ),
              child: MonoSubject(
                name: categories[index],
              ), // 👉 dùng widget MonoSubject
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
    final screenWidth = MediaQuery.of(context).size.width;//screen size
    return Container(
      width: screenWidth*0.8,
      padding: EdgeInsets.all(screenWidth*0.05),
      decoration: BoxDecoration(
        color: AppColors.headerBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.headerBackground)),
      child: Row(
        children: [Icon(Icons.folder), SizedBox(width: 8), Text(name)],
      ),
    );
  }
}
