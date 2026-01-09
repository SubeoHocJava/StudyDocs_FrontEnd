import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/constants/app_colors.dart';
import 'package:studydocs/features/explore/presentation/bloc/explore_bloc.dart';

/// Bottom sheet "Khám phá" xuất hiện từ dưới lên, giống thiết kế.
class ExploreBottomSheet extends StatefulWidget {
  const ExploreBottomSheet({super.key});

  @override
  State<ExploreBottomSheet> createState() => _ExploreBottomSheetState();
}

class _ExploreBottomSheetState extends State<ExploreBottomSheet> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ExploreBloc>().add(const ExploreStarted());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    // Tính height để không che bottom nav (footer)
    // Screen height - bottom nav (khoảng 70-80px) - safe area bottom
    final bottomNavHeight = 70.0;
    final safeAreaBottom = mediaQuery.padding.bottom;
    final maxHeight = mediaQuery.size.height * 0.45; // Tối đa 45% màn hình
    final heightWithMargin = mediaQuery.size.height - bottomNavHeight - safeAreaBottom - 20;
    final height = heightWithMargin < maxHeight ? heightWithMargin : maxHeight;

    return Container(
      height: height,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: BlocBuilder<ExploreBloc, ExploreState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thanh kéo nhỏ trên đầu
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                const Text(
                  'Khám phá',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.profileName,
                  ),
                ),
                const SizedBox(height: 8),

                // Dòng hiển thị trường hiện tại (nếu có)
                if (state.currentSchool != null) ...[
                  Row(
                    children: [
                      const Icon(
                        Icons.school,
                        size: 20,
                        color: AppColors.docSmallText,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          state.currentSchool!.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.profileName,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],

                // Ô search (màu sắc giống thiết kế)
                TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    context
                        .read<ExploreBloc>()
                        .add(ExploreSearchChanged(value));
                  },
                  decoration: InputDecoration(
                    hintText: state.currentSchool != null
                        ? 'Tìm kiếm trong ${state.currentSchool!.shortName ?? state.currentSchool!.name}...'
                        : 'Tìm kiếm trường, khoa, tài liệu...',
                    prefixIcon: const Icon(Icons.search, color: AppColors.docSmallText),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                        color: AppColors.headerForeground,
                        width: 1.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                        color: AppColors.headerForeground,
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                        color: AppColors.headerForeground,
                        width: 2,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                if (state.isLoading) const LinearProgressIndicator(),

                const SizedBox(height: 8),

                // Kết quả tìm kiếm trường (mock)
                Expanded(
                  child: Builder(
                    builder: (context) {
                      if (state.query.trim().isEmpty) {
                        return const Center(
                          child: Text(
                            'Nhập tên trường để tìm kiếm',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.docSmallText,
                            ),
                          ),
                        );
                      }

                      if (state.results.isEmpty && !state.isLoading) {
                        return const Center(
                          child: Text(
                            'Không tìm thấy trường phù hợp',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.docSmallText,
                            ),
                          ),
                        );
                      }

                      return ListView.separated(
                        itemCount: state.results.length,
                        separatorBuilder: (_, __) =>
                            const Divider(height: 1, color: AppColors.headerBackground),
                        itemBuilder: (context, index) {
                          final school = state.results[index];
                          return ListTile(
                            leading: const Icon(
                              Icons.school_outlined,
                              color: AppColors.headerForeground,
                            ),
                            title: Text(
                              school.name,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.profileName,
                              ),
                            ),
                            onTap: () {
                              // TODO: Sau này điều hướng sang trang tài liệu của trường này
                              debugPrint('Chọn trường: ${school.name}');
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}


