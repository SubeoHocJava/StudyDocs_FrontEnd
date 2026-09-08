import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:studydocs/core/constants/app_colors.dart';
import 'package:studydocs/screens/home/presentation/widgets/home_document_card_with_bloc.dart';
import 'package:studydocs/core/widgets/feat/search/presentation/voice_search_bottom_sheet.dart';
import 'package:studydocs/screens/home/data/repository/home_repository_impl.dart';
import 'package:studydocs/data/datasource/impl/document_remote_datasource_impl.dart';
import '../logic/home_bloc.dart';
import '../logic/home_event.dart';
import '../logic/home_state.dart';



class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dataSource = DocumentRemoteDataSourceImpl();
    final repository = HomeRepositoryImpl(dataSource);

    return BlocProvider(
      create: (_) => HomeBloc(
        repository: repository,
      )..add(const HomeStarted()),
      child: _HomeContent(repository: repository),
    );
  }
}

class _HomeContent extends StatefulWidget {
  final HomeRepositoryImpl repository;

  const _HomeContent({
    required this.repository,
  });

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 240) {
      context.read<HomeBloc>().add(const HomeNextPageRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () async {
            context.read<HomeBloc>().add(const HomeStarted());
          },
          child: ListView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          children: [
            const _HomeHero(),
            if (state.isInitialLoading)
              const _InitialLoading()
            else if (state.error != null && state.items.isEmpty)
              _HomeError(message: state.error!)
            else ...[
              const SizedBox(height: 14),
              ...state.items.map(
                (doc) => Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: SizedBox(
                    height: 166,
                    child: HomeDocumentCardWithBloc(
                      doc: doc,
                      repository: widget.repository,
                    ),
                  ),
                ),
              ),
              if (state.isLoadingMore) const _LoadMoreIndicator(),
              if (!state.hasMore && state.items.isNotEmpty)
                const SizedBox(height: 18),
            ],
          ],
        ));
      },
    );
  }
}

class _HomeHero extends StatelessWidget {
  const _HomeHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 226,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            AppColors.customColor3,
            AppColors.customColor6,
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          _OutlinedTitle('StudyDocs'),
          SizedBox(height: 6),
          Text(
            'Chia sẻ kiến thức - Học hỏi cùng nhau',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.white,
              fontSize: 22,
              fontWeight: FontWeight.w500,
              height: 1.15,
            ),
          ),
          SizedBox(height: 28),
          _SearchBarMock(),
        ],
      ),
    );
  }
}

class _OutlinedTitle extends StatelessWidget {
  final String text;

  const _OutlinedTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w800,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 4
              ..color = AppColors.white,
          ),
        ),
        Text(
          text,
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 34,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _SearchBarMock extends StatefulWidget {
  const _SearchBarMock();

  @override
  State<_SearchBarMock> createState() => _SearchBarMockState();
}

class _SearchBarMockState extends State<_SearchBarMock> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _submitSearch(BuildContext context, String value) {
    if (value.trim().isEmpty) return;
    context.go('/explore', extra: value.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Container(
        height: 42,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            const SizedBox(width: 10),
            const Icon(Icons.search, color: AppColors.primary, size: 30),
            const SizedBox(width: 8),
            Expanded(
              child: Material(
                color: AppColors.transparent,
                child: TextField(
                  focusNode: _focusNode,
                  controller: _controller,
                  onSubmitted: (val) {
                    _submitSearch(context, val);
                  },
                  onTap: () {},
                  textAlignVertical: TextAlignVertical.center,
                  textInputAction: TextInputAction.search,
                  decoration: const InputDecoration(
                    hintText: 'Tìm kiếm các khóa học, bài giảng, tài liệu',
                    hintStyle: TextStyle(
                      color: AppColors.gray,
                      fontSize: 12,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                  ),
                  style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () async {
                final result = await showModalBottomSheet<String>(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (_) => const VoiceSearchBottomSheet(),
                );
                if (!context.mounted) return;
                
                if (result != null && result.isNotEmpty) {
                  _controller.text = result;
                  _submitSearch(context, result);
                }
              },
              icon: Icon(Icons.mic, color: Theme.of(context).iconTheme.color, size: 26),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints.tightFor(width: 40, height: 40),
            ),
            const SizedBox(width: 4),
          ],
        ),
      ),
    );
  }
}

class _InitialLoading extends StatelessWidget {
  const _InitialLoading();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

class _LoadMoreIndicator extends StatelessWidget {
  const _LoadMoreIndicator();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 18),
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2.5),
        ),
      ),
    );
  }
}

class _HomeError extends StatelessWidget {
  final String message;

  const _HomeError({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            'Không tải được trang chủ.\n$message',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.black),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => context.read<HomeBloc>().add(const HomeStarted()),
            child: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }
}
