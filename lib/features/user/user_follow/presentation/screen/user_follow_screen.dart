import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repository/user_follow_repository.dart';
import '../../domain/repository/impl/user_follow_repository_impl.dart';
import '../../logic/user_follow_bloc.dart';
import '../../logic/user_follow_event.dart';
import '../../logic/user_follow_state.dart';
import '../widget/user_follow.dart';

class UserFollowScreen extends StatelessWidget {
  final int initialTab;
  const UserFollowScreen({super.key, this.initialTab = 0});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              UserFollowBloc(UserFollowRepositoryImpl() as UserFollowRepository)
                ..add(LoadUserFollowLists()),
      child: BlocBuilder<UserFollowBloc, UserFollowState>(
        builder: (context, state) {
          if (state is UserFollowLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserFollowLoaded) {
            return UserFollowWidget(
              initialTab: initialTab,
              followers: state.followers,
              following: state.following,
              onUnfollow: (userId) {
                context.read<UserFollowBloc>().add(UnfollowUserEvent(userId));
              },
              onRemoveFollower: (userId) {
                context.read<UserFollowBloc>().add(RemoveUserFollowerEvent(userId));
              },
              onFollow: (userId) {
                context.read<UserFollowBloc>().add(UserFollowUserEvent(userId));
              },
              onUserTap: (userId) {
                // context.push('${AppRoutes.profile}/$userId');
              },
            );
          } else if (state is UserFollowError) {
            return Center(child: Text('Lỗi: ${state.message}'));
          }
          return const Center(child: Text('Đang tải...'));
        },
      ),
    );
  }
}
