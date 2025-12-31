import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/features/home/presentation/widget/home_banner.dart';
import 'package:studydocs/core/widgets/header.dart';
import 'package:studydocs/core/widgets/document/ListDocument.dart';
import 'package:studydocs/core/widgets/document/model/list_document_ui.dart';
import 'package:studydocs/core/constants/app_colors.dart';
import 'package:studydocs/core/utils/responsive_helper.dart';
import 'package:studydocs/features/home/logic/home_bloc.dart';
import 'package:studydocs/features/home/logic/home_event.dart';
import 'package:studydocs/features/home/logic/home_state.dart';
import 'package:studydocs/features/home/domain/entity/document_entity.dart';

// Adapter to use DocumentEntity with the reused ListDocument widget
class HomeDocumentAdapter extends DocumentUiList {
  final DocumentEntity entity;
  
  const HomeDocumentAdapter(this.entity);

  @override
  String get id => entity.id.toString();
  
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

  @override
  void initState() {
    super.initState();
    // Load documents on init
    context.read<HomeBloc>().add(const LoadDocumentsEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearch(String query) {
    context.read<HomeBloc>().add(UpdateSearchQueryEvent(query));
  }

  @override
  Widget build(BuildContext context) {
    // Note: HomePage is used inside MainScreen, which provides Scaffold and BottomNav.
    // However, if we want the top Header, we usually put it here or in MainScreen.
    // The user wants Header to stay, but the bottom nav in current HomePage is redundant.
    return Scaffold(
      appBar: const Header(
        selectedIndex: 0, // Mark Home as active in menu
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<HomeBloc>().add(const RefreshDocumentsEvent());
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: _buildBody(state),
          );
        },
      ),
    );
  }

  Widget _buildBody(HomeState state) {
    if (state is HomeLoading || state is HomeInitial) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }

    if (state is HomeError) {
      return _buildErrorView(state.message);
    }

    if (state is HomeLoaded) {
      final popularDocs = state.popularDocuments.map((e) => HomeDocumentAdapter(e)).toList();
      final recentDocs = state.recentDocuments.map((e) => HomeDocumentAdapter(e)).toList();
      final filteredDocs = state.filteredDocuments.map((e) => HomeDocumentAdapter(e)).toList();

      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner with Search
            HomeBanner(
              onSearchChanged: _handleSearch,
              height: 200,
            ),

            const SizedBox(height: 24),

            // Search results view
            if (state.searchQuery.isNotEmpty) ...[
               _buildSectionTitle('Kết quả tìm kiếm: "${state.searchQuery}"'),
               if (filteredDocs.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Center(child: Text('Không tìm thấy tài liệu nào', style: TextStyle(color: AppColors.docSmallText))),
                )
              else
                ListDocument(
                  filteredDocs,
                  onDownload: (doc) { /* TODO */ },
                  onSave: (doc) { /* TODO */ },
                ),
            ] else ...[
               // Default categorized view
               _buildSectionTitle('Tài liệu phổ biến'),
               ListDocument(
                 popularDocs,
                 onDownload: (doc) {},
                 onSave: (doc) {},
               ),

               const SizedBox(height: 24),

               _buildSectionTitle('Tài liệu mới nhất'),
               ListDocument(
                 recentDocs,
                 onDownload: (doc) {},
                 onSave: (doc) {},
               ),
            ],

            const SizedBox(height: 24),
          ],
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
          const Icon(Icons.error_outline, size: 64, color: AppColors.docSmallText),
          const SizedBox(height: 16),
          const Text('Đã xảy ra lỗi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.read<HomeBloc>().add(const RefreshDocumentsEvent()),
            child: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }
}