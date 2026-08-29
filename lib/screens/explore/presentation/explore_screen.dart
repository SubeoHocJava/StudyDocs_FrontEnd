import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:studydocs/core/widgets/feat/explore/presentation/widgets/explore_header.dart';
import 'package:studydocs/core/widgets/feat/explore/presentation/widgets/explore_search_bar.dart';

import 'package:studydocs/data/model/document_model/response/document_compact_model.dart';
import 'package:studydocs/core/widgets/feat/document/docs_card/presentation/document_card_compact.dart';
import 'package:studydocs/core/widgets/feat/document/docs_card/presentation/document_card_horizontal.dart';

import '../data/repository/explore_repository_impl.dart';

import '../logic/explore_bloc.dart';
import '../logic/explore_event.dart';
import '../logic/explore_state.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final repository = ExploreRepositoryImpl();
        return ExploreBloc(
          repository: repository,
        )..add(FetchExploreDataEvent());
      },
      child: const ExploreView(),
    );
  }
}

class ExploreView extends StatelessWidget {
  const ExploreView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExploreBloc, ExploreState>(
      builder: (context, state) {
        if (state is ExploreLoading) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is ExploreLoaded) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ExploreHeader(
                    title: 'Khám phá',
                    subtitle: state.data.universityName,
                    subtitleIcon: Icons.account_balance, // A school/building icon
                  ),
                  ExploreSearchBar(
                    hintText: state.data.hintText,
                    onTap: () {
                      debugPrint('Search'); // Mock search action as requested
                    },
                  ),
                  Expanded(
                    child: SingleChildScrollView(
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
                                return DocumentCardHorizontal(doc: doc);
                              },
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is ExploreError) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: Text(state.message)),
          );
        }

        return const Scaffold(
          backgroundColor: Colors.white,
          body: SizedBox.shrink(),
        );
      },
    );
  }
}
