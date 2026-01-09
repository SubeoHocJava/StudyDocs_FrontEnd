import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/constants/app_colors.dart';
import 'package:studydocs/features/profile/logic/profile_bloc.dart';
import 'package:studydocs/features/profile/logic/profile_state.dart';

/// Widget that displays activity summary from ProfileBloc
/// Shows: Upload count, Likes count, Comments count
class ActivitySummaryCard extends StatelessWidget {
  const ActivitySummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoaded) {
          return _buildCard(
            numMyUpload: state.numMyUpload,
            numMyLikes: state.numMyLikes,
            numMyComment: state.numMyComment,
          );
        } else if (state is ProfileLoading) {
          return _buildLoadingCard();
        } else {
          return _buildErrorCard();
        }
      },
    );
  }

  Widget _buildCard({
    required int numMyUpload,
    required int numMyLikes,
    required int numMyComment,
  }) {
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
            "Thống kê hoạt động",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.profileName,
            ),
          ),
          const SizedBox(height: 16),
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumn(
                  label: "Đăng tải",
                  value: numMyUpload,
                ),
                const VerticalDivider(color: Colors.grey, thickness: 1),
                _buildStatColumn(
                  label: "Lượt thích",
                  value: numMyLikes,
                ),
                const VerticalDivider(color: Colors.grey, thickness: 1),
                _buildStatColumn(
                  label: "Bình luận",
                  value: numMyComment,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn({required String label, required int value}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value.toString(),
          style: const TextStyle(
            fontSize: 28,
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.docSmallText,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }

  Widget _buildErrorCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Text(
          "Không thể tải thống kê hoạt động",
          style: TextStyle(color: AppColors.docSmallText),
        ),
      ),
    );
  }
}
