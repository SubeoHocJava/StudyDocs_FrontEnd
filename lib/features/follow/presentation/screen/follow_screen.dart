import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:studydocs/core/widgets/header.dart';
import 'package:studydocs/core/widgets/bottom_nav.dart';
import 'package:studydocs/core/router/app_router.dart';
import 'package:studydocs/features/follow/data/repository/follow_repository_impl.dart';
import 'package:studydocs/features/follow/logic/follow_bloc.dart';
import 'package:studydocs/features/follow/logic/follow_event.dart';
import 'package:studydocs/features/follow/logic/follow_state.dart';
import 'package:studydocs/features/follow/presentation/widget/follow.dart';

class FollowScreen extends StatelessWidget {
  final int initialTab;
  const FollowScreen({super.key, this.initialTab = 0});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              FollowBloc(FollowRepositoryImpl())..add(LoadFollowLists()),
      child: Scaffold(
        appBar: const Header(isDefault: false, headerTitle: 'Theo dõi'),
        body: BlocBuilder<FollowBloc, FollowState>(
          builder: (context, state) {
            if (state is FollowLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is FollowLoaded) {
              return FollowWidget(
                initialTab: initialTab,
                followers: state.followers,
                following: state.following,
                onUnfollow: (userId) {
                  context.read<FollowBloc>().add(UnfollowUser(userId));
                },
                onRemoveFollower: (userId) {
                  context.read<FollowBloc>().add(RemoveFollower(userId));
                },
                onFollow: (userId) {
                  context.read<FollowBloc>().add(FollowUser(userId));
                },
                onUserTap: (userId) {
                  context.push('${AppRoutes.profile}/$userId');
                },
              );
            } else if (state is FollowError) {
              return Center(child: Text('Lỗi: ${state.message}'));
            }
            return const Center(child: Text('Đang tải...'));
          },
        ),
        bottomNavigationBar: BottomNav(
          currentIndex: -1, // No tab active
          onTap: (index) {
            // Navigate to the nested tab root.
            switch (index) {
              case 0:
                context.go(AppRoutes.home);
                break;
              case 1:
                context.go(AppRoutes.library);
                break;
              case 2:
                context.go(AppRoutes.explore);
                break;
              case 3:
                context.go(AppRoutes.notifications);
                break;
              default:
                context.go(AppRoutes.home);
            }
          },
        ),
      ),
    );
  }
}
