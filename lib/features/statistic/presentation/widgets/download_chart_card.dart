import 'package:flutter/material.dart';
import 'package:studydocs/core/constants/app_colors.dart';
import 'package:studydocs/features/statistic/domain/entity/statistic_entity.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StatisticChartData {
  final String label;
  final int count;

  StatisticChartData(this.label, this.count);
}

class DownloadChartCard extends StatelessWidget {
  final StatisticEntity statistics;

  const DownloadChartCard({
    super.key,
    required this.statistics,
  });

  @override
  Widget build(BuildContext context) {
    // Transform StatisticEntity into chart data
    final chartData = [
      StatisticChartData('Hôm nay', statistics.dayCount),
      StatisticChartData('Tháng này', statistics.monthCount),
      StatisticChartData('Năm nay', statistics.yearCount),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300, width: 1),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Thống kê tài liệu được tải xuống",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.profileName,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "số lượng file",
            style: TextStyle(
              fontSize: 12,
              color: AppColors.docSmallText,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 280,
            child: SfCartesianChart(
              primaryXAxis: const CategoryAxis(
                majorGridLines: MajorGridLines(width: 0),
                labelStyle: TextStyle(
                  fontSize: 12,
                  color: AppColors.docSmallText,
                ),
              ),
              primaryYAxis: const NumericAxis(
                minimum: 0,
                interval: 1,
                labelStyle: TextStyle(
                  fontSize: 12,
                  color: AppColors.docSmallText,
                ),
              ),
              plotAreaBorderWidth: 0,
              series: <CartesianSeries>[
                ColumnSeries<StatisticChartData, String>(
                  dataSource: chartData,
                  xValueMapper: (StatisticChartData data, _) => data.label,
                  yValueMapper: (StatisticChartData data, _) => data.count,
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF2196F3), // Blue
                      Color(0xFF00BCD4), // Cyan
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                  animationDuration: 1500,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(8),
                  ),
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    textStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  width: 0.6,
                  spacing: 0.2,
                ),
              ],
              tooltipBehavior: TooltipBehavior(
                enable: true,
                format: 'point.x: point.y files',
                color: AppColors.primary,
                textStyle: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

