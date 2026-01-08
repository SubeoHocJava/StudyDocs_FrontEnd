import 'package:flutter/material.dart';
import 'package:studydocs/core/utils/responsive_helper.dart';

/// Layout cơ sở cho tất cả các modal notification
/// - Tạo container với chiều rộng full màn hình
/// - Thêm indicator bar ở trên cùng (thanh kéo)
/// - Hỗ trợ scroll nếu nội dung dài
/// - Padding và constraints chuẩn cho modal bottom sheet
class NotificationModalLayout extends StatelessWidget {
  final Widget child;

  const NotificationModalLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle (Fixed)
          Container(
            width: responsive.widthPercent(15),
            height: 4,
            margin: EdgeInsets.symmetric(
              vertical: responsive.isMobile ? 12 : 16,
            ),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 0, 15, 76),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Content (Scrollable)
          Flexible(
             child: SingleChildScrollView(
               child: ConstrainedBox(
                 constraints: BoxConstraints(
                   maxWidth: responsive.width,
                   minWidth: responsive.width,
                 ),
                 child: Container(
                   padding: responsive.defaultPadding,
                   child: child,
                 ),
               ),
             ),
          ),
        ],
      ),
    );
  }
}

