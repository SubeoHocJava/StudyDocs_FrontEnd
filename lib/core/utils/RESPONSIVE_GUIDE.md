## Cách Sử Dụng

### Cách 1: Sử dụng Extension (Khuyên dùng)
```dart
Widget build(BuildContext context) {
  // Kiểm tra device type
  if (context.isMobile) {
    // Code cho mobile
  }
  
  // Lấy screen dimensions
  final width = context.screenWidth;
  final height = context.screenHeight;
  
  // Sử dụng responsive helper
  final cardWidth = context.responsive.getCardWidth(
    columns: context.responsive.getGridColumnCount(
      mobile: 2,
      tablet: 3,
      desktop: 4,
    ),
  );
  
  return Container(
    padding: context.responsive.defaultPadding,
    width: context.responsive.widthPercent(50), // 50% width
  );
}
```

### Cách 2: Sử dụng Class trực tiếp
```dart
Widget build(BuildContext context) {
  final responsive = ResponsiveHelper(context);
  
  return Container(
    width: responsive.width,
    height: responsive.height,
    padding: responsive.defaultPadding,
  );
}
```

## Các Tính Năng Chính

### 1. Device Type Detection
```dart
context.isMobile   // width < 600
context.isTablet   // 600 <= width < 1024
context.isDesktop  // width >= 1024
```

### 2. Responsive Values
```dart
// Chọn giá trị theo device
final padding = context.responsive.responsiveValue(
  mobile: 16.0,
  tablet: 24.0,
  desktop: 32.0,
);

final fontSize = context.responsive.fontSize(14); // Tự động scale
```

### 3. Width/Height Helpers
```dart
// Percentage width
context.responsive.widthPercent(50)  // 50% width

// Width với padding
context.responsive.widthWithPadding(100, padding: 16)

// Percentage height
context.responsive.heightPercent(30) // 30% height
```

### 4. Grid System
```dart
// Số cột theo device
final columns = context.responsive.getGridColumnCount(
  mobile: 2,
  tablet: 3,
  desktop: 4,
);

// Tính card width cho grid
final cardWidth = context.responsive.getCardWidth(
  columns: 2,
  spacing: 12,
  padding: 16,
);
```

### 5. Padding Helpers
```dart
context.responsive.defaultPadding  // Padding mặc định responsive
context.responsive.screenPadding   // Padding đầy đủ 4 phía
```

## Breakpoints

Mặc định:
- **Mobile**: < 600px
- **Tablet**: 600px - 1024px  
- **Desktop**: >= 1024px

Có thể tùy chỉnh trong `ResponsiveHelper`:
```dart
static const double mobileBreakpoint = 600;
static const double tabletBreakpoint = 1024;
static const double desktopBreakpoint = 1440;
```

## Ví Dụ Thực Tế

### Ví dụ 1: Responsive Grid
```dart
Widget build(BuildContext context) {
  final columns = context.responsive.getGridColumnCount(
    mobile: 2,
    tablet: 3,
    desktop: 4,
  );
  
  final cardWidth = context.responsive.getCardWidth(
    columns: columns,
    spacing: 12,
  );
  
  return Wrap(
    spacing: 12,
    runSpacing: 12,
    children: items.map((item) {
      return SizedBox(
        width: cardWidth,
        child: ItemCard(item),
      );
    }).toList(),
  );
}
```

### Ví dụ 2: Responsive Padding & Font
```dart
Container(
  padding: context.responsive.defaultPadding,
  child: Text(
    'Hello',
    style: TextStyle(
      fontSize: context.responsive.fontSize(16),
    ),
  ),
)
```

### Ví dụ 3: Conditional Layout
```dart
Widget build(BuildContext context) {
  if (context.isDesktop) {
    return DesktopLayout();
  } else if (context.isTablet) {
    return TabletLayout();
  } else {
    return MobileLayout();
  }
}
```

## So Sánh Với Thư Viện Khác

### Option 1: ResponsiveHelper (Hiện tại) ✅
- ✅ Không cần thêm dependency
- ✅ Nhẹ, dễ hiểu
- ✅ Hoàn toàn kiểm soát được
- ✅ Tái sử dụng được

### Option 2: flutter_screenutil
- Cần thêm vào `pubspec.yaml`
- Phải setup ban đầu
- Dựa trên design size (375x812)

### Option 3: Chỉ dùng MediaQuery trực tiếp
- ❌ Không tái sử dụng được
- ❌ Code lặp lại nhiều
- ❌ Khó maintain
```

