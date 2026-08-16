import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/repository/home_repository.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _repository;

  HomeBloc({
    required HomeRepository repository,
  })  : _repository = repository,
        super(const HomeState.initial()) {
    on<HomeStarted>(_onStarted);
    on<HomeNextPageRequested>(_onNextPageRequested);
  }

  Future<void> _onStarted(
    HomeStarted event,
    Emitter<HomeState> emit,
  ) async {
    emit(
      state.copyWith(
        items: const [],
        page: 0,
        total: 0,
        hasMore: true,
        isInitialLoading: true,
        isLoadingMore: false,
        clearError: true,
      ),
    );

    try {
      final result = await _repository.getHomeDocuments(
        page: 1,
        pageSize: state.pageSize,
      );
      emit(
        state.copyWith(
          items: result.items,
          page: result.page,
          pageSize: result.pageSize,
          total: result.total,
          hasMore: result.hasMore,
          isInitialLoading: false,
          clearError: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          isInitialLoading: false,
          error: error.toString(),
        ),
      );
    }
  }

  Future<void> _onNextPageRequested(
    HomeNextPageRequested event,
    Emitter<HomeState> emit,
  ) async {
    if (state.isInitialLoading || state.isLoadingMore || !state.hasMore) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true, clearError: true));

    try {
      final result = await _repository.getHomeDocuments(
        page: state.page + 1,
        pageSize: state.pageSize,
      );
      emit(
        state.copyWith(
          items: [...state.items, ...result.items],
          page: result.page,
          pageSize: result.pageSize,
          total: result.total,
          hasMore: result.hasMore,
          isLoadingMore: false,
          clearError: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          isLoadingMore: false,
          error: error.toString(),
        ),
      );
    }
  }
}
