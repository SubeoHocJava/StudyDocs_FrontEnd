import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/usecases/get_follow_data_usecase.dart';
import '../domain/repositories/follow_repository.dart';
import 'follow_event.dart';
import 'follow_state.dart';

class FollowBloc extends Bloc<FollowEvent, FollowState> {
  late final FollowRepository _repository;
  late final GetFollowDataUseCase _getFollowDataUseCase;

  FollowBloc() : super(FollowInitialState()) {
    // Tự khởi tạo luôn repository và usecase
    _repository = FollowRepositoryImpl();
    _getFollowDataUseCase = GetFollowDataUseCase(_repository);

    // Đăng ký Event
    on<LoadFollowDataEvent>(_onLoadFollowData);
  }

  Future<void> _onLoadFollowData(
      LoadFollowDataEvent event,
      Emitter<FollowState> emit,
      ) async {
    emit(FollowLoadingState());
    try {
      final followData = await _getFollowDataUseCase();
      emit(FollowLoadedState(followData));
    } catch (e) {
      emit(FollowErrorState(e.toString()));
    }
  }
}