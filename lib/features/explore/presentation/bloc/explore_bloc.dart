import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/features/explore/domain/entity/school_entity.dart';
import 'package:studydocs/features/explore/domain/usecase/search_schools_usecase.dart';
import 'package:studydocs/core/error/error_mapper.dart';
import 'package:studydocs/core/exceptions/api_exception.dart';

/// -----------------------------
/// EVENT
/// -----------------------------

abstract class ExploreEvent extends Equatable {
  const ExploreEvent();

  @override
  List<Object?> get props => [];
}

/// Load trường hiện tại + clear kết quả tìm kiếm (lần đầu mở sheet).
class ExploreStarted extends ExploreEvent {
  const ExploreStarted();
}

/// Khi user nhập vào ô search.
class ExploreSearchChanged extends ExploreEvent {
  final String query;

  const ExploreSearchChanged(this.query);

  @override
  List<Object?> get props => [query];
}

/// -----------------------------
/// STATE
/// -----------------------------

class ExploreState extends Equatable {
  final SchoolEntity? currentSchool;
  final List<SchoolEntity> results;
  final String query;
  final bool isLoading;
  final String? errorMessage;

  const ExploreState({
    this.currentSchool,
    this.results = const [],
    this.query = '',
    this.isLoading = false,
    this.errorMessage,
  });

  ExploreState copyWith({
    SchoolEntity? currentSchool,
    List<SchoolEntity>? results,
    String? query,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ExploreState(
      currentSchool: currentSchool ?? this.currentSchool,
      results: results ?? this.results,
      query: query ?? this.query,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [currentSchool, results, query, isLoading, errorMessage];
}

/// -----------------------------
/// BLOC
/// -----------------------------

class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  final SearchSchoolsUseCase searchSchoolsUseCase;
  final GetCurrentSchoolUseCase getCurrentSchoolUseCase;

  ExploreBloc({
    required this.searchSchoolsUseCase,
    required this.getCurrentSchoolUseCase,
  }) : super(const ExploreState()) {
    on<ExploreStarted>(_onStarted);
    on<ExploreSearchChanged>(_onSearchChanged);
  }

  Future<void> _onStarted(
    ExploreStarted event,
    Emitter<ExploreState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final school = await getCurrentSchoolUseCase();
      emit(
        state.copyWith(
          currentSchool: school,
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: _getErrorMessage(e),
        ),
      );
    }
  }

  Future<void> _onSearchChanged(
    ExploreSearchChanged event,
    Emitter<ExploreState> emit,
  ) async {
    final query = event.query;
    emit(
      state.copyWith(
        query: query,
        isLoading: true,
        errorMessage: null,
      ),
    );

    try {
      final results = await searchSchoolsUseCase(query);
      emit(
        state.copyWith(
          results: results,
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: _getErrorMessage(e),
        ),
      );
    }
  }

  String _getErrorMessage(Object error) {
    if (error is ApiException) {
      return ErrorMapper.map(int.tryParse(error.code ?? ''));
    }
    return ErrorMapper.map(500);
  }
}
