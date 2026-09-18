import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:studydocs/core/widgets/feat/explore/presentation/widgets/explore_header.dart';
import 'package:studydocs/core/widgets/feat/explore/presentation/widgets/explore_search_bar.dart';

import 'package:studydocs/data/model/document_model/response/document_compact_model.dart';
import 'package:studydocs/core/widgets/feat/document/docs_card/presentation/document_card_compact.dart';
import 'package:studydocs/core/widgets/feat/document/docs_card/presentation/document_card_horizontal_with_bloc.dart';
import 'package:studydocs/core/widgets/feat/document/docs_card/domain/repository/document_repository.dart';
import 'package:studydocs/data/datasource/impl/document_remote_datasource_impl.dart';
import 'package:studydocs/screens/home/data/repository/home_repository_impl.dart';

import '../data/repository/explore_repository_impl.dart';

import '../logic/explore_bloc.dart';
import '../logic/explore_event.dart';
import '../logic/explore_state.dart';
import 'package:studydocs/core/constants/app_colors.dart';

class ExploreScreen extends StatelessWidget {
  final String? initialQuery;

  const ExploreScreen({super.key, this.initialQuery});

  @override
  Widget build(BuildContext context) {
    final docRepository = HomeRepositoryImpl(DocumentRemoteDataSourceImpl());

    return BlocProvider(
      create: (context) {
        final repository = ExploreRepositoryImpl();
        final bloc = ExploreBloc(
          repository: repository,
        );

        if (initialQuery != null && initialQuery!.isNotEmpty) {
          bloc.add(SearchExploreEvent(initialQuery!));
        } else {
          bloc.add(FetchExploreDataEvent());
        }

        return bloc;
      },
      child: ExploreView(
        initialQuery: initialQuery,
        documentRepository: docRepository,
      ),
    );
  }
}

class ExploreView extends StatelessWidget {
  final String? initialQuery;
  final DocumentRepository documentRepository;
  
  const ExploreView({
    super.key, 
    this.initialQuery,
    required this.documentRepository,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header (Chỉ hiện khi ở trạng thái Loaded)
            BlocBuilder<ExploreBloc, ExploreState>(
              buildWhen: (previous, current) => 
                  current is ExploreLoaded || current is ExploreSearching || current is ExploreSearchResult,
              builder: (context, state) {
                if (state is ExploreLoaded) {
                  return ExploreHeader(
                    title: 'Khám phá',
                    subtitle: state.data.universityName,
                    subtitleIcon: Icons.account_balance,
                  );
                }
                return const SizedBox.shrink();
              },
            ),

            // 2. Thanh tìm kiếm (Giữ nguyên không bị rebuild toàn bộ)
            BlocBuilder<ExploreBloc, ExploreState>(
              buildWhen: (previous, current) => current is ExploreLoaded,
              builder: (context, state) {
                final hint = (state is ExploreLoaded) 
                    ? state.data.hintText 
                    : 'Tìm kiếm tài liệu, môn học...';
                return ExploreSearchBar(
                  hintText: hint,
                  initialQuery: initialQuery,
                );
              },
            ),

            // 3. Nội dung chính (Thay đổi theo trạng thái)
            Expanded(
              child: BlocBuilder<ExploreBloc, ExploreState>(
                builder: (context, state) {
                  if (state is ExploreLoading || state is ExploreSearching) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is ExploreSearchResult) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          child: Text(
                            state.results.isEmpty
                                ? 'Không tìm thấy kết quả cho "${state.query}"'
                                : '${state.results.length} kết quả cho "${state.query}"',
                            style: const TextStyle(fontSize: 13, color: AppColors.grey),
                          ),
                        ),
                        Expanded(
                          child: state.results.isEmpty
                              ? const Center(child: Text('Không có tài liệu phù hợp'))
                              : RefreshIndicator(
                                  onRefresh: () async {
                                    context.read<ExploreBloc>().add(SearchExploreEvent(state.query));
                                  },
                                  child: ListView.separated(
                                    physics: const AlwaysScrollableScrollPhysics(),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  itemCount: state.results.length,
                                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                                  itemBuilder: (context, index) {
                                    return SizedBox(
                                      height: 150,
                                      child: DocumentCardHorizontalWithBloc(
                                        doc: state.results[index],
                                        repository: documentRepository,
                                      ),
                                    );
                                  },
                                ),
                              ),
                        ),
                      ],
                    );
                  }

                  if (state is ExploreLoaded) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<ExploreBloc>().add(FetchExploreDataEvent());
                      },
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1. Tài liệu nổi bật (Trending)
                          if (state.data.mostLikedDocuments.isNotEmpty) ...[
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: Text(
                                'Tài liệu nổi bật',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 160,
                              child: ListView.separated(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                scrollDirection: Axis.horizontal,
                                itemCount: state.data.mostLikedDocuments.length,
                                separatorBuilder: (_, __) => const SizedBox(width: 12),
                                itemBuilder: (context, index) {
                                  final summary = state.data.mostLikedDocuments[index];
                                  final compact = DocumentCompactModel(
                                    id: summary.id,
                                    title: summary.title,
                                    thumbnail: summary.thumbnail,
                                  );
                                  return DocumentCardCompact(
                                    doc: compact,
                                    width: 120,
                                    thumbHeight: 100,
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],

                          // 2. Mới đăng tải (Newest)
                          if (state.data.newestDocuments.isNotEmpty) ...[
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: Text(
                                'Mới đăng tải',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ListView.separated(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: state.data.newestDocuments.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 8),
                              itemBuilder: (context, index) {
                                final doc = state.data.newestDocuments[index];
                                return SizedBox(
                                  height: 150,
                                  child: DocumentCardHorizontalWithBloc(
                                    doc: doc,
                                    repository: documentRepository,
                                  ),
                                );
                              },
                            ),
                          ],
                        ],
                      ),
                    ));
                  }

                  if (state is ExploreError) {
                    return Center(child: Text(state.message));
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
