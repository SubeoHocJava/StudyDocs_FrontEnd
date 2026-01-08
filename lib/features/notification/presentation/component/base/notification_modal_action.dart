import 'package:flutter/material.dart';
import 'package:studydocs/features/notification/domain/enum/notification_type.dart';
import 'package:studydocs/features/notification/presentation/component/helpers/notification_modal_size_helper.dart';

class NotificationTypeIcon extends StatelessWidget {
  final String type;
  final double size;

  const NotificationTypeIcon({
    super.key,
    required this.type,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final config = NotificationTypeStore.fromType(type);
    final innerSize = (size * 0.5).clamp(16.0, size);

    return CircleAvatar(
      radius: size / 2,
      backgroundColor: config?.backgroundColor ?? Colors.red,
      child: Padding(
        padding: EdgeInsets.all(size * 0.12),
        child: config == null
            ? Icon(Icons.info, color: Colors.white, size: innerSize)
            : Image.asset(
          config.src,
          width: innerSize,
          height: innerSize,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Icon(
            Icons.info,
            color: Colors.white,
            size: innerSize,
          ),
        ),
      ),
    );
  }
}


class NotificationModalAction extends StatelessWidget {
  final String label;
  final String? asset;
  final IconData? icon;
  final double size;
  final VoidCallback onPressed;

  const NotificationModalAction({
    super.key,
    required this.label,
    this.asset,
    this.icon,
    required this.size,
    required this.onPressed,
  }) : assert(asset != null || icon != null,
  'Either asset or icon must be provided');

  @override
  Widget build(BuildContext context) {
    final sizes = NotificationModalSizeHelper.calculate(context);

    return TextButton.icon(
      onPressed: onPressed,
      icon: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: asset != null
            ? Image.asset(
          asset!,
          width: size,
          height: size,
          fit: BoxFit.contain,
        )
            : Icon(
          icon!,
          size: size,
          color: const Color.fromARGB(255, 0, 15, 76),
        ),
      ),
      label: Text(
        label,
        style: TextStyle(
          fontSize: sizes.clampedTextSize,
          color: const Color.fromARGB(255, 0, 15, 76),
        ),
      ),
    );
  }
}


