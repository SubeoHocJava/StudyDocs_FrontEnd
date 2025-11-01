// Tính toán kích thước cho modal (icon, button, font) theo kích thước màn hình.
// Mục đích: giữ tỉ lệ hợp lý giữa các thành phần trong modal trên điện thoại/tablet.
class NotificationModalSizeHelper {
  static NotificationModalSizes calculate(double screenWidth) {
    // reuse breakpoints similar to layout helper; clamp values for extremes
    if (screenWidth >= 720) {
      return const NotificationModalSizes(
        iconSize: 80,
        buttonIconSize: 64,
        fontSize: 18,
        textSize: 18,
      );
    } else if (screenWidth >= 360) {
      return const NotificationModalSizes(
        iconSize: 56,
        buttonIconSize: 48,
        fontSize: 16,
        textSize: 16,
      );
    } else {
      return const NotificationModalSizes(
        iconSize: 44,
        buttonIconSize: 40,
        fontSize: 14,
        textSize: 14,
      );
    }
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

