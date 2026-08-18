import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:studydocs/core/widgets/feat/explore/presentation/widgets/explore_header.dart';
import 'package:studydocs/core/widgets/feat/explore/presentation/widgets/explore_search_bar.dart';

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
                      print('Search'); // Mock search action as requested
                    },
                  ),
                  // Space for future content
                  const Expanded(
                    child: Center(
                      child: Text('Nội dung khám phá sẽ hiển thị ở đây'),
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
