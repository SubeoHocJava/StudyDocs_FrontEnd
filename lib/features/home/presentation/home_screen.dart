import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/data/datasource/impl/academic_remote_datasource_impl.dart';
import 'package:studydocs/core/network/dio_client.dart';
import 'package:studydocs/features/explore/domain/repository/impl/explore_repository_impl.dart';
import 'package:studydocs/features/explore/domain/usecase/search_schools_usecase.dart';
import 'package:studydocs/features/explore/presentation/bloc/explore_bloc.dart';
import 'package:studydocs/features/explore/presentation/widgets/explore_bottom_sheet.dart';
import 'package:studydocs/features/home/presentation/widget/home_banner.dart';
import 'package:studydocs/core/widgets/document/ListDocument.dart';
import 'package:studydocs/core/widgets/document/model/list_document_ui.dart';
import 'package:studydocs/core/constants/app_colors.dart';
import 'package:studydocs/features/home/logic/home_bloc.dart';
import 'package:studydocs/features/home/logic/home_event.dart';
import 'package:studydocs/features/home/logic/home_state.dart';
import 'package:studydocs/features/home/domain/entity/document_entity.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

// Adapter to use DocumentEntity with the reused ListDocument widget
class HomeDocumentAdapter extends DocumentUiList {
  final DocumentEntity entity;

  const HomeDocumentAdapter(this.entity);

  @override
  String get id => entity.id.toString();

  @override
  String? get fileId => entity.fileId;

  @override
  String get title => entity.title;

  @override
  String? get category => entity.category;

  @override
  String? get institution => entity.institution;

  @override
  String? get createdAt => entity.academicYear;

  @override
  String? get thumbnailUrl => entity.thumbnailUrl;

  @override
  int get likesCount => entity.likesCount ?? 0;

  @override
  int get commentsCount => entity.commentsCount ?? 0;

  @override
  bool get isLiked => false;

  @override
  bool get isSaved => false;
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  late final stt.SpeechToText _speech;
  bool _speechEnabled = false;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    // Load documents on init
    context.read<HomeBloc>().add(const LoadDocumentsEvent());

    _speech = stt.SpeechToText();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    try {
      _speechEnabled = await _speech.initialize();
    } catch (_) {
      _speechEnabled = false;
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearch(String query) {
    context.read<HomeBloc>().add(UpdateSearchQueryEvent(query));
  }

  Future<void> _toggleListening() async {
    if (!_speechEnabled) {
      await _initSpeech();
      if (!_speechEnabled) return;
    }

    if (_isListening) {
      await _speech.stop();
      if (mounted) {
        setState(() => _isListening = false);
      }
      return;
    }

    final ok = await _speech.listen(
      onResult: (result) {
        final text = result.recognizedWords;
        _searchController.text = text;
        _searchController.selection = TextSelection.fromPosition(
          TextPosition(offset: _searchController.text.length),
        );
        _handleSearch(text);

        if (result.finalResult) {
          _speech.stop();
          if (mounted) {
            setState(() => _isListening = false);
          }
        }
      },
      listenMode: stt.ListenMode.confirmation,
      cancelOnError: true,
      partialResults: true,
    );

    if (mounted) {
      setState(() => _isListening = ok);
    }
  }

  @override
  Widget build(BuildContext context) {
    // HomePage is displayed inside the MainScreen shell which already contains Header.
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () async {
            context.read<HomeBloc>().add(const RefreshDocumentsEvent());
            await Future.delayed(const Duration(milliseconds: 500));
          },
          child: _buildBody(state),
        );
      },
    );
  }

  Widget _buildBody(HomeState state) {
    if (state is HomeLoading || state is HomeInitial) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (state is HomeError) {
      return _buildErrorView(state.message);
    }

    if (state is HomeLoaded) {
      final popularDocs =
          state.popularDocuments.map((e) => HomeDocumentAdapter(e)).toList();
      final recentDocs =
          state.recentDocuments.map((e) => HomeDocumentAdapter(e)).toList();
      final filteredDocs =
          state.filteredDocuments.map((e) => HomeDocumentAdapter(e)).toList();

      return SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeBanner(
                controller: _searchController,
                onSearchChanged: _handleSearch,
                onMicTap: _toggleListening,
                height: 200,
              ),

              const SizedBox(height: 24),

              // Search results view
              if (state.searchQuery.isNotEmpty) ...[
                _buildSectionTitle('Kết quả tìm kiếm: "${state.searchQuery}"'),
                if (filteredDocs.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Center(
                      child: Text(
                        'Không tìm thấy tài liệu nào',
                        style: TextStyle(color: AppColors.docSmallText),
                      ),
                    ),
                  )
                else
                  ListDocument(
                    filteredDocs,
                    onDownload: (doc) {
                      /* TODO */
                    },
                    onSave: (doc) {
                      /* TODO */
                    },
                  ),
              ] else ...[
                // Default categorized view
                _buildSectionTitle('Tài liệu phổ biến'),
                if (popularDocs.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      'Chưa có tài liệu phổ biến nào',
                      style: TextStyle(
                        color: AppColors.docSmallText,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  )
                else
                  ListDocument(
                    popularDocs,
                    onDownload: (doc) {},
                    onSave: (doc) {},
                  ),

                const SizedBox(height: 24),

                _buildSectionTitle('Tài liệu mới nhất'),
                if (recentDocs.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      'Chưa có tài liệu mới nào',
                      style: TextStyle(
                        color: AppColors.docSmallText,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  )
                else
                  ListDocument(
                    recentDocs,
                    onDownload: (doc) {},
                    onSave: (doc) {},
                  ),
              ],

              const SizedBox(height: 24),
            ],
          ),
        ),
      );
    }

    return const SizedBox();
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.profileName,
        ),
      ),
    );
  }

  Widget _buildErrorView(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: AppColors.docSmallText,
          ),
          const SizedBox(height: 16),
          const Text(
            'Đã xảy ra lỗi',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed:
                () =>
                    context.read<HomeBloc>().add(const RefreshDocumentsEvent()),
            child: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }

  /// Xây dựng overlay Khám phá với BLoC và mock data.
  Widget _buildExploreOverlay() {
    final dioClient = context.read<DioClient>();
    final academicDataSource = AcademicRemoteDataSourceImpl(
      dioClient: dioClient,
    );
    final repo = ExploreRepositoryImpl(remote: academicDataSource);
    final searchUseCase = SearchSchoolsUseCase(repository: repo);
    final getCurrentSchoolUseCase = GetCurrentSchoolUseCase(repository: repo);

    return BlocProvider(
      create:
          (_) => ExploreBloc(
            searchSchoolsUseCase: searchUseCase,
            getCurrentSchoolUseCase: getCurrentSchoolUseCase,
          ),
      child: const ExploreBottomSheet(),
    );
  }
}
