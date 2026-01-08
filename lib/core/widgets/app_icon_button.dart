import 'package:flutter/material.dart';

class AppIconButton extends StatelessWidget {
  final IconData? iconData;
  final String? assetPath;
  final VoidCallback? onPressed; // có thể null (disabled)
  final double size;
  final Color? color;
  final EdgeInsetsGeometry padding;

  const AppIconButton({
    super.key,
    this.iconData,
    this.assetPath,
    this.onPressed,
    this.size = 24,
    this.color,
    this.padding = const EdgeInsets.all(8),
  }) : assert(iconData != null || assetPath != null,
  'Cần iconData hoặc assetPath');

  @override
  Widget build(BuildContext context) {
    final Widget iconWidget = iconData != null
        ? Icon(iconData, size: size, color: color)
        : ImageIcon(AssetImage(assetPath!), size: size, color: color);

    return IconButton(
      icon: iconWidget,
      onPressed: onPressed,
      padding: padding,
      // Ensure a reasonable tap target (48x48) for accessibility and reliability
      constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
      splashRadius: size + 6,
    );
  }
}
