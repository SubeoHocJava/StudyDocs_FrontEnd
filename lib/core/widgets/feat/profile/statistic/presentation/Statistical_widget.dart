
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/repositories/mock_statistic_repository_impl.dart';
import '../domain/usecases/get_statistic_usecase.dart';
import '../logic/statistic_bloc.dart';
import '../logic/statistic_event.dart';
import '../logic/statistic_state.dart';

class Statistics extends StatelessWidget {
  const Statistics({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StatisticBloc(
        getStatisticUseCase: GetStatisticUseCase(MockStatisticRepositoryImpl()),
      )..add(LoadStatisticData()),
      child: BlocBuilder<StatisticBloc, StatisticState>(
        builder: (context, state) {
          if (state is StatisticLoading || state is StatisticInitial) {
            return _buildCardContainer(
              context,
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          } else if (state is StatisticError) {
            return _buildCardContainer(
              context,
              child: Center(child: Text("Lỗi: ${state.message}")),
            );
          } else if (state is StatisticLoaded) {
            final data = state.statisticData;
            return _buildCardContainer(
              context,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Thống kê hoạt động",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 16),
                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatColumn(context, data.totalDocuments.toString(), "Đăng tải"),
                        VerticalDivider(
                          color: Colors.grey[300],
                          thickness: 1,
                          width: 1,
                        ),
                        _buildStatColumn(context, data.totalLikes.toString(), "Lượt thích"),
                        VerticalDivider(
                          color: Colors.grey[300],
                          thickness: 1,
                          width: 1,
                        ),
                        _buildStatColumn(context, data.totalComments.toString(), "Bình luận"),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildCardContainer(BuildContext context, {required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildStatColumn(BuildContext context, String value, String label) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              color: Color(0xFF1D24C9), // Deep blue color matching the image
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF64748B), // Slate gray color for labels
            ),
          ),
        ],
      ),
    );
  }
}
