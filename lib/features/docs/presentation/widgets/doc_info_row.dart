import 'package:flutter/material.dart';

class DocInfoRow extends StatelessWidget {
  final String text;
  final String iconPath;

  const DocInfoRow({super.key, required this.text, required this.iconPath});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(iconPath, width: 20, height: 20),
        const SizedBox(width: 6),
        Expanded(child: Text(text)),
      ],
    );
  }
}
