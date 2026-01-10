import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:studydocs/core/constants/app_colors.dart';
import 'package:studydocs/features/statistic/presentation/bloc/statistic_bloc.dart';
import 'package:studydocs/features/statistic/presentation/bloc/statistic_event.dart';
import 'package:studydocs/features/statistic/presentation/bloc/statistic_state.dart';
import 'package:studydocs/features/statistic/presentation/widgets/activity_summary_card.dart';
import 'package:studydocs/features/statistic/presentation/widgets/download_chart_card.dart';

/// Statistics screen showing activity summary and download chart
/// Displays data from ProfileBloc and StatisticBloc
class StatisticScreen extends StatelessWidget {
  const StatisticScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<StatisticBloc, StatisticState>(
          builder: (context, state) {
            if (state is StatisticLoading || state is StatisticInitial) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            if (state is StatisticError) {
              return _buildErrorView(context, state.message);
            }

            if (state is StatisticLoaded) {
              return RefreshIndicator(
            onRefresh: () async {
              context
                  .read<StatisticBloc>()
                  .add(const RefreshDownloadStatisticsEvent());
              await Future.delayed(const Duration(milliseconds: 500));
            },
            color: AppColors.primary,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    const Text(
                      'Thống kê',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Activity Summary Card (from ProfileBloc)
                    const ActivitySummaryCard(),

                    const SizedBox(height: 24),

                    // Download Chart Card (from StatisticBloc)
                    DownloadChartCard(statistics: state.statistics),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
        ),
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.docSmallText,
            ),
            const SizedBox(height: 16),
            const Text(
              'Đã xảy ra lỗi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.profileName,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.docSmallText,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context
                    .read<StatisticBloc>()
                    .add(const LoadDownloadStatisticsEvent());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }
}
