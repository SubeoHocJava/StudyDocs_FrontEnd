import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/widgets/feat/profile/follow/logic/follow_event.dart';
import 'package:studydocs/core/widgets/feat/profile/statistic/logic/statistic_event.dart';
import '../domain/usecase/get_user_info_usecase.dart';

import '../../../../core/widgets/feat/profile/Infor_user/logic/InforUserBloc.dart';
import '../../../../core/widgets/feat/profile/Infor_user/logic/InforUserEvent.dart';
import '../../../../core/widgets/feat/profile/follow/logic/follow_bloc.dart';
import '../../../../core/widgets/feat/profile/statistic/logic/statistic_bloc.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {

  final InforUserBloc inforUserBloc;
  final FollowBloc followBloc;
  final StatisticBloc statisticBloc;
  final GetUserInfoUseCase getUserInfoUseCase;

  ProfileBloc({
    required this.inforUserBloc,
    required this.followBloc,
    required this.statisticBloc,
    required this.getUserInfoUseCase,
  }) : super(ProfileInitialState()) {
    on<ProfileInitial>((event, emit) async {

      emit(ProfileLoadingState());

      try {
        // gọi load data
        final user = await getUserInfoUseCase();
        
        inforUserBloc.add(LoadUserInfor(user));
        followBloc.add(LoadFollowDataEvent(user));
        statisticBloc.add(LoadStatisticData(user));

        emit(ProfileLoadedState(user));
      } catch (e) {
        emit(ProfileErrorState(e.toString()));
      }
    });
  }

  @override
  Future<void> close() {
    inforUserBloc.close();
    followBloc.close();
    statisticBloc.close();
    return super.close();
  }
}
