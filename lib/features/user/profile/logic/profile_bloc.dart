import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/widgets/feat/profile/follow/logic/follow_event.dart';
import 'package:studydocs/core/widgets/feat/profile/statistic/logic/statistic_event.dart';



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

  ProfileBloc( {required this.inforUserBloc,
      required this.followBloc,
      required this.statisticBloc,}) : super(ProfileInitialState()) {
    on<ProfileInitial>((event, emit) async {

      emit(ProfileLoadingState());

      // gọi load data
      inforUserBloc.add(LoadUserInfor(event.userId));
      followBloc.add(LoadFollowDataEvent());
      statisticBloc.add(LoadStatisticData());

      emit(ProfileLoadedState());
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