import 'package:flutter/material.dart';
import 'package:studydocs/core/utils/responsive_helper.dart';

/// Helper để tính toán các giá trị layout cho notification component
/// sử dụng ResponsiveHelper để đảm bảo tính nhất quán
class NotificationLayoutHelper {
  /// Tính toán các giá trị layout dựa trên ResponsiveHelper
  static NotificationLayoutValues calculate(BuildContext context) {
    final responsive = ResponsiveHelper(context);
    
    return NotificationLayoutValues(
      horizontalPadding: responsive.responsiveValue(
        mobile: 16.0,
        tablet: 24.0,
        desktop: 32.0,
      ),
      verticalPadding: responsive.responsiveValue(
        mobile: 12.0,
        tablet: 16.0,
        desktop: 20.0,
      ),
      spacing: responsive.responsiveValue(
        mobile: 12.0,
        tablet: 16.0,
        desktop: 20.0,
      ),
      iconSize: responsive.responsiveValue(
        mobile: 48.0,
        tablet: 56.0,
        desktop: 64.0,
      ),
      fontSize: responsive.fontSize(14.0),
    );
  }
}

class NotificationLayoutValues {
  final double horizontalPadding;
  final double verticalPadding;
  final double spacing;
  final double iconSize;
  final double fontSize;

  const NotificationLayoutValues({
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.spacing,
    required this.iconSize,
    required this.fontSize,
  });
}

