import 'package:flutter/material.dart';

class ActivityStatistics extends StatelessWidget {
  final int numMyUpload;
  final int numMyLikes;
  final int numMyComment;

  const ActivityStatistics({
    super.key,
    this.numMyUpload = 0,
    this.numMyLikes = 0,
    this.numMyComment = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem('Uploads', numMyUpload),
        _buildStatItem('Likes', numMyLikes),
        _buildStatItem('Comments', numMyComment),
      ],
    );
  }

  Widget _buildStatItem(String label, int value) {
    return Column(
      children: [
        Text(value.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
