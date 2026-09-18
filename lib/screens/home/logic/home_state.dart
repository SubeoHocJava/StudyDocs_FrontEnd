import 'package:equatable/equatable.dart';
import 'package:studydocs/data/model/document_model/response/document_summary_model.dart';

class HomeState extends Equatable {
  final List<DocumentSummaryModel> items;
  final int page;
  final int pageSize;
  final int total;
  final bool hasMore;
  final bool isInitialLoading;
  final bool isLoadingMore;
  final String? error;

  const HomeState({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.total,
    required this.hasMore,
    required this.isInitialLoading,
    required this.isLoadingMore,
    this.error,
  });

  const HomeState.initial()
      : items = const [],
        page = 0,
        pageSize = 5,
        total = 0,
        hasMore = true,
        isInitialLoading = false,
        isLoadingMore = false,
        error = null;

  HomeState copyWith({
    List<DocumentSummaryModel>? items,
    int? page,
    int? pageSize,
    int? total,
    bool? hasMore,
    bool? isInitialLoading,
    bool? isLoadingMore,
    String? error,
    bool clearError = false,
  }) {
    return HomeState(
      items: items ?? this.items,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      total: total ?? this.total,
      hasMore: hasMore ?? this.hasMore,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: clearError ? null : error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        items,
        page,
        pageSize,
        total,
        hasMore,
        isInitialLoading,
        isLoadingMore,
        error,
      ];
}
