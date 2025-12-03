import 'package:flutter/material.dart';
import 'package:studydocs/core/utils/responsive_helper.dart';

/// Helper để tính toán kích thước cho modal component
/// sử dụng ResponsiveHelper để đảm bảo tính nhất quán
class NotificationModalSizeHelper {
  static NotificationModalSizes calculate(BuildContext context) {
    final responsive = ResponsiveHelper(context);
    
    return NotificationModalSizes(
      iconSize: responsive.responsiveValue(
        mobile: 56.0,
        tablet: 72.0,
        desktop: 80.0,
      ),
      buttonIconSize: responsive.responsiveValue(
        mobile: 48.0,
        tablet: 56.0,
        desktop: 64.0,
      ),
      fontSize: responsive.fontSize(16.0),
      textSize: responsive.fontSize(16.0),
    );
  }
}

class NotificationModalSizes {
  final double iconSize;
  final double buttonIconSize;
  final double fontSize;
  final double textSize;

  const NotificationModalSizes({
    required this.iconSize,
    required this.buttonIconSize,
    required this.fontSize,
    required this.textSize,
  });

  double get clampedIconSize => iconSize.clamp(40, 80);
  double get clampedButtonIconSize => buttonIconSize.clamp(30, 100);
  double get clampedFontSize => fontSize.clamp(14, 20);
  double get clampedTextSize => textSize.clamp(12.0, 18.0);
  double get clampedSmallButtonIconSize => (buttonIconSize * 0.8).clamp(24, 90);
}

