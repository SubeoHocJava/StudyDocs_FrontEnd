import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        leading: BackButton(color: Theme.of(context).appBarTheme.foregroundColor),
        title: Text(
          "Thống kê",
          style: TextStyle(
              color: Theme.of(context).appBarTheme.foregroundColor,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: BlocBuilder<StatisticBloc, StatisticState>(
          builder: (context, state) {
            if (state is StatisticLoading || state is StatisticInitial) {
              return Center(
                child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary),
              );
            }

            if (state is StatisticError) {
              return _buildErrorView(context, state.message);
            }

            if (state is StatisticLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<StatisticBloc>().add(
                    const RefreshDownloadStatisticsEvent(),
                  );
                  await Future.delayed(const Duration(milliseconds: 500));
                },
                color: Theme.of(context).colorScheme.primary,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
            Text(
              'Đã xảy ra lỗi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.bodyLarge?.color,
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
                context.read<StatisticBloc>().add(
                  const LoadDownloadStatisticsEvent(),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
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
