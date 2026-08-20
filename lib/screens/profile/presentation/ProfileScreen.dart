import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/feat/profile/Infor_user/logic/InforUserBloc.dart';
import '../../../../core/widgets/feat/profile/Infor_user/presentation/InforUser.dart';
import '../../../../core/widgets/feat/profile/follow/logic/follow_bloc.dart';
import '../../../../core/widgets/feat/profile/follow/presentation/follow_widget.dart';
import '../../../../core/widgets/feat/profile/statistic/logic/statistic_bloc.dart';
import '../../../../core/widgets/feat/profile/statistic/presentation/Statistical_widget.dart';
import '../logic/profile_bloc.dart';
import '../logic/profile_event.dart';
import '../logic/profile_state.dart';

import '../domain/repository/user_repository.dart';

class ProfileScreen extends StatelessWidget {
  final String? userId;

  const ProfileScreen({super.key, this.userId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [

        BlocProvider(
          create: (context) => InforUserBloc(),
        ),

        BlocProvider(
          create: (context) => FollowBloc(),
        ),

        BlocProvider(
          create: (context) => StatisticBloc(),
        ),

        BlocProvider(
          create: (context) => ProfileBloc(
            inforUserBloc: context.read<InforUserBloc>(),
            followBloc: context.read<FollowBloc>(),
            statisticBloc: context.read<StatisticBloc>(), 
            userRepository: UserRepository(),
          )..add(ProfileInitial(userId ?? "me")),

        ),

      ],
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProfileLoadedState) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  InforUser(),
                  Follow(),
                  Statistics(),
                ],
              ),
            );
          }

          if (state is ProfileErrorState) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Không tải được hồ sơ.\n${state.message}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}