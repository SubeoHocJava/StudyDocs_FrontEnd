import 'package:flutter/material.dart';

class PdfPreview extends StatelessWidget {
  final double height;
  final String label;

  const PdfPreview({super.key, this.height = 420, this.label = "PDF full ở đây"});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Center(child: Text(label)),
    );
  }
}
