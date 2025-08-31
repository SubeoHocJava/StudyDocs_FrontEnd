import 'package:flutter/material.dart';

class SubjectCategories extends StatelessWidget {
  final List<String> items = [
    "Khoá học Flutter",
    "Khoá học Java",
    "Khoá học Kotlin",
  ];

  @override
  Widget build(BuildContext context) {
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
          itemCount: items.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 4.0,
                horizontal: 16.0,
              ),
              child: MonoSubject(
                name: items[index],
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
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey)),
      child: Row(
        children: [Icon(Icons.folder), SizedBox(width: 8), Text(name)],
      ),
    );
  }
}
