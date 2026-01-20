import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../constants/app_colors.dart';

/// Widget thông báo lỗi bám lề phải, bo góc chuẩn và né icon
class ErrorNotificationWidget extends StatelessWidget {
  final String errorCode;
  final String errorDescription;
  final VoidCallback? onDismissed;
  final Key? dismissKey;

  const ErrorNotificationWidget({
    super.key,
    required this.errorCode,
    required this.errorDescription,
    this.onDismissed,
    this.dismissKey,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final backgroundColor = isDark ? AppColors.surfaceDark : AppColors.white;
    final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return Dismissible(
      key: dismissKey ?? UniqueKey(),
      direction: DismissDirection.horizontal,
      onDismissed: (_) => onDismissed?.call(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Align(
          alignment: Alignment.centerRight,
          child: IntrinsicWidth(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // 1. Phông nền
                Container(
                  constraints: const BoxConstraints(minHeight: 48, maxWidth: 320),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 14,
                            color: textColor,
                            fontFamily: theme.textTheme.bodyMedium?.fontFamily,
                          ),
                          children: [
                            TextSpan(
                              text: errorCode,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const TextSpan(text: ' - '),
                            TextSpan(text: errorDescription),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // 2. Viền bo tròn chuẩn có khoảng hở
                Positioned.fill(
                  child: CustomPaint(
                    painter: PillBorderPainter(
                      color: AppColors.danger,
                      strokeWidth: 2.0,
                    ),
                  ),
                ),

                // 3. Icon Warning
                Positioned(
                  top: -12,
                  right: -4,
                  child: Container(
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(2),
                    child: const Icon(
                      Icons.warning_rounded,
                      color: AppColors.danger,
                      size: 28,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PillBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  PillBorderPainter({required this.color, this.strokeWidth = 2.0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final double r = size.height / 2;
    final double w = size.width;
    final double h = size.height;

    final path = Path();
    
    // Bắt đầu từ đoạn trên cùng, cách góc phải một khoảng để né icon
    path.moveTo(w - r * 1.2, 0);
    
    // Vẽ cạnh trên qua trái
    path.lineTo(r, 0);
    
    // Bo góc trái trên (Convex)
    path.arcTo(
    Rect.fromCircle(center: Offset(r, r), radius: r),
    -math.pi / 2,
    -math.pi / 2,
    false,
    );
    
    // Bo góc trái dưới
    path.arcTo(
    Rect.fromCircle(center: Offset(r, h - r), radius: r),
    math.pi,
    -math.pi / 2,
    false,
    );
    
    // Cạnh dưới qua phải
    path.lineTo(w - r, h);
    
    // Bo góc phải dưới
    path.arcTo(
    Rect.fromCircle(center: Offset(w - r, h - r), radius: r),
    math.pi / 2,
    -math.pi / 2,
    false,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
