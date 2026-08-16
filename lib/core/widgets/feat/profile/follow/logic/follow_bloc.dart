import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/models/follow_entity.dart';

import '../domain/repositories/follow_repository.dart';
import 'follow_event.dart';
import 'follow_state.dart';

class FollowBloc extends Bloc<FollowEvent, FollowState> {
  late final FollowRepository _repository;
  FollowBloc() : super(FollowInitialState()) {
    // Tự khởi tạo luôn repository
    _repository = FollowRepositoryImpl();

    // Đăng ký Event
    on<LoadFollowDataEvent>(_onLoadFollowData);
  }

  Future<void> _onLoadFollowData(
      LoadFollowDataEvent event,
      Emitter<FollowState> emit,
      ) async {
    emit(FollowLoadingState());
    try {
      final user = event.user;
      final followData = FollowEntity(
        numFollowMe: user.followersCount,
        numMeFollow: user.followingCount,
      );
      emit(FollowLoadedState(followData));
    } catch (e) {
      emit(FollowErrorState(e.toString()));
    }
  }
}