import 'package:flutter/material.dart';
import 'package:studydocs/core/utils/notification_icon_helper.dart';
import 'package:studydocs/features/notification_template/domain/entity/notification_template_entity.dart';

class NotificationTemplateItem extends StatelessWidget {
  final NotificationTemplateEntity template;
  final VoidCallback onDelete;
  final VoidCallback onView;

  const NotificationTemplateItem({
    super.key,
    required this.template,
    required this.onDelete,
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          _buildIcon(),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  template.templateSubject,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  template.name, // Display channel or description as subtitle
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onView,
            icon: const Icon(Icons.remove_red_eye_outlined, color: Colors.grey),
            tooltip: 'Xem chi tiết',
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            tooltip: 'Xóa',
          ),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    return NotificationIconHelper.getIcon(template.type);
  }
}
