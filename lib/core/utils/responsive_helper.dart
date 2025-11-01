import 'package:flutter/material.dart';

/// Helper class để xử lý responsive cho các kích thước màn hình khác nhau
/// 
/// Cách sử dụng:
/// ```dart
/// final responsive = ResponsiveHelper(context);
/// responsive.widthPercent(50) // 50% chiều rộng màn hình
/// responsive.isMobile // true/false
/// ```
class ResponsiveHelper {
  final BuildContext context;
  
  ResponsiveHelper(this.context);
  
  // Kích thước màn hình
  double get width => MediaQuery.of(context).size.width;
  double get height => MediaQuery.of(context).size.height;
  
  // Điểm ngắt kích thước (có thể tùy chỉnh)
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;
  static const double desktopBreakpoint = 1440;
  
  // Kiểm tra loại thiết bị
  bool get isMobile => width < mobileBreakpoint;
  bool get isTablet => width >= mobileBreakpoint && width < tabletBreakpoint;
  bool get isDesktop => width >= tabletBreakpoint;
  
  // Hướng màn hình
  bool get isPortrait => MediaQuery.of(context).orientation == Orientation.portrait;
  bool get isLandscape => MediaQuery.of(context).orientation == Orientation.landscape;
  
  // Helper cho Padding/Margin
  EdgeInsets get defaultPadding => EdgeInsets.symmetric(
    horizontal: isMobile ? 16.0 : isTablet ? 24.0 : 32.0,
  );
  
  EdgeInsets get screenPadding => EdgeInsets.all(
    isMobile ? 16.0 : isTablet ? 24.0 : 32.0,
  );
  
  // Helper cho chiều rộng
  double widthPercent(double percent) => width * (percent / 100);
  double widthWithPadding(double percent, {double padding = 16}) {
    return (width - (padding * 2)) * (percent / 100);
  }
  
  // Helper cho chiều cao
  double heightPercent(double percent) => height * (percent / 100);
  
  // Helper cho kích thước font (tự động scale theo thiết bị)
  double fontSize(double baseSize) {
    if (isMobile) return baseSize;
    if (isTablet) return baseSize * 1.1;
    return baseSize * 1.2;
  }
  
  // Helper để tính số cột trong grid
  int getGridColumnCount({int? mobile, int? tablet, int? desktop}) {
    if (isDesktop) return desktop ?? 4;
    if (isTablet) return tablet ?? 3;
    return mobile ?? 2;
  }
  
  // Helper để tính chiều rộng card trong danh sách
  double getCardWidth({
    int columns = 2,
    double spacing = 12,
    double padding = 16,
  }) {
    final totalPadding = padding * 2;
    final totalSpacing = spacing * (columns - 1);
    return (width - totalPadding - totalSpacing) / columns;
  }
  
  // Helper để chọn giá trị responsive theo loại thiết bị
  T responsiveValue<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop && desktop != null) return desktop;
    if (isTablet && tablet != null) return tablet;
    return mobile;
  }
}

/// Extension methods để truy cập dễ dàng hơn
extension ResponsiveExtension on BuildContext {
  ResponsiveHelper get responsive => ResponsiveHelper(this);
  
  // Truy cập nhanh các thuộc tính thường dùng
  bool get isMobile => ResponsiveHelper(this).isMobile;
  bool get isTablet => ResponsiveHelper(this).isTablet;
  bool get isDesktop => ResponsiveHelper(this).isDesktop;
  
  double get screenWidth => ResponsiveHelper(this).width;
  double get screenHeight => ResponsiveHelper(this).height;
}

