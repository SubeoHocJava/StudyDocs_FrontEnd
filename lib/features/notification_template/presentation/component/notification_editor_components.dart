import 'package:flutter/material.dart';

class NotificationEditorSection extends StatelessWidget {
  final List<Widget> children;

  const NotificationEditorSection({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class NotificationInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const NotificationInfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            SizedBox(
              width: 80, 
              child: Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600))
            ),
            Expanded(child: Text(value, style: TextStyle(fontSize: 14, color: Colors.grey.shade900))),
          ],
        )
    );
  }
}

class NotificationEditorHeader extends StatelessWidget {
  final String label;
  final VoidCallback onInsert;

  const NotificationEditorHeader({super.key, required this.label, required this.onInsert});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        TextButton.icon(
          onPressed: onInsert,
          icon: const Icon(Icons.add, size: 16),
          label: const Text('Chèn từ khóa', style: TextStyle(fontSize: 13)),
          style: TextButton.styleFrom(
            backgroundColor: Colors.blue.shade50,
            foregroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        )
      ],
    );
  }
}
