class NotificationLayoutHelper {
  /// Calculate layout values based on available width.
  /// Uses simple breakpoints (small, medium, large) so components
  /// scale consistently across screen sizes.
  static NotificationLayoutValues calculate(double maxWidth) {
    if (maxWidth >= 720) {
      return const NotificationLayoutValues(
        horizontalPadding: 24,
        verticalPadding: 16,
        spacing: 16,
        iconSize: 56,
        fontSize: 16,
      );
    } else if (maxWidth >= 360) {
      return const NotificationLayoutValues(
        horizontalPadding: 16,
        verticalPadding: 12,
        spacing: 12,
        iconSize: 48,
        fontSize: 14,
      );
    } else {
      // small phones
      return const NotificationLayoutValues(
        horizontalPadding: 12,
        verticalPadding: 8,
        spacing: 8,
        iconSize: 40,
        fontSize: 13,
      );
    }
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

