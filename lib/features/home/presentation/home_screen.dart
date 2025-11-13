import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/widgets/header.dart';
import '../../../core/widgets/bottom_nav.dart';
import '../../../core/widgets/document_horizontal.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/responsive_helper.dart';
import 'bloc/home_bloc.dart';
import '../domain/entity/document_entity.dart';
import 'component/home_banner.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Tải danh sách tài liệu khi màn hình được khởi tạo
    context.read<HomeBloc>().add(const LoadDocumentsEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearch(String query) {
    if (query.trim().isEmpty) {
      context.read<HomeBloc>().add(const LoadDocumentsEvent());
    } else {
      context.read<HomeBloc>().add(SearchDocumentsEvent(query));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<HomeBloc>().add(const RefreshDocumentsEvent());
              // Đợi state cập nhật
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: _buildBody(state),
          );
        },
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          _handleNavigation(index);
        },
      ),
    );
  }

  Widget _buildBody(HomeState state) {
    if (state is HomeLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      );
    }

    if (state is HomeError) {
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
            Text(
              'Đã xảy ra lỗi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.profileName,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              state.message,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.docSmallText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.read<HomeBloc>().add(const RefreshDocumentsEvent());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    if (state is HomeLoaded) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner với thanh tìm kiếm
            HomeBanner(
              onSearchChanged: _handleSearch,
              onSearchTap: () {
                // Tùy chọn: Điều hướng đến màn hình tìm kiếm
              },
              height: 200,
            ),

            const SizedBox(height: 24),

            // Phần tài liệu phổ biến
            DocumentHorizontalList(
              sectionTitle: 'Tài liệu phổ biến',
              documents: _convertToDocumentItems(
                state.popularDocuments,
              ),
              itemHeight: 140,
              onSeeAllTap: () {
                // TODO: Điều hướng đến trang tất cả tài liệu phổ biến
              },
            ),

            const SizedBox(height: 24),

            // Phần tài liệu mới nhất
            DocumentHorizontalList(
              sectionTitle: 'Tài liệu mới nhất',
              documents: _convertToDocumentItems(
                state.recentDocuments,
              ),
              itemHeight: 140,
              onSeeAllTap: () {
                // TODO: Điều hướng đến trang tất cả tài liệu mới nhất
              },
            ),

            // Phần kết quả tìm kiếm (khi đang tìm kiếm)
            if (state.searchQuery != null && state.searchQuery!.isNotEmpty) ...[
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(
                      'Kết quả tìm kiếm: "${state.searchQuery}"',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.profileName,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        _searchController.clear();
                        context.read<HomeBloc>().add(const LoadDocumentsEvent());
                      },
                      child: const Text(
                        'Xóa',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              if (state.documents.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Center(
                    child: Text(
                      'Không tìm thấy tài liệu nào',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.docSmallText,
                      ),
                    ),
                  ),
                )
              else
                Padding(
                  padding: context.responsive.defaultPadding,
                  child: Column(
                    children: state.documents.map((doc) {
                      return DocumentHorizontal(
                        title: doc.title,
                        author: doc.author,
                        thumbnailUrl: doc.thumbnailUrl,
                        category: doc.category,
                        institution: doc.institution,
                        pageCount: doc.pageCount,
                        academicYear: doc.academicYear,
                        viewCount: doc.viewCount,
                        downloadCount: doc.downloadCount,
                        likesCount: doc.likesCount,
                        commentsCount: doc.commentsCount,
                        rating: doc.rating,
                        onTap: () {
                          // TODO: Điều hướng đến trang chi tiết tài liệu
                        },
                        onDownloadTap: () {
                          // TODO: Xử lý tải xuống
                        },
                        onBookmarkTap: () {
                          // TODO: Xử lý bookmark
                        },
                        height: 140,
                      );
                    }).toList(),
                  ),
                ),
            ],

            // Phần tất cả tài liệu (khi không tìm kiếm)
            if (state.searchQuery == null || state.searchQuery!.isEmpty) ...[
              const SizedBox(height: 24),
              DocumentHorizontalList(
                sectionTitle: 'Tất cả tài liệu',
                documents: _convertToDocumentItems(state.documents),
                itemHeight: 140,
                onSeeAllTap: () {
                  // TODO: Điều hướng đến trang tất cả tài liệu
                },
              ),
            ],

            const SizedBox(height: 24),
          ],
        ),
      );
    }

    // Trạng thái khởi tạo
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.primary,
      ),
    );
  }

  List<DocumentHorizontalItem> _convertToDocumentItems(
    List<DocumentEntity> entities,
  ) {
    return entities.map((entity) {
      return DocumentHorizontalItem(
        title: entity.title,
        author: entity.author,
        thumbnailUrl: entity.thumbnailUrl,
        category: entity.category,
        institution: entity.institution,
        pageCount: entity.pageCount,
        academicYear: entity.academicYear,
        viewCount: entity.viewCount,
        downloadCount: entity.downloadCount,
        likesCount: entity.likesCount,
        commentsCount: entity.commentsCount,
        rating: entity.rating,
        onTap: () {
          // TODO: Điều hướng đến trang chi tiết tài liệu
          // Có thể truyền entity.id hoặc toàn bộ entity vào màn hình chi tiết
        },
        onDownloadTap: () {
          // TODO: Xử lý tải xuống tài liệu
        },
        onBookmarkTap: () {
          // TODO: Xử lý bookmark tài liệu
        },
      );
    }).toList();
  }

  void _handleNavigation(int index) {
    switch (index) {
      case 0:
        // Trang chủ - đã ở đây rồi
        break;
      case 1:
        // Thư viện
        // TODO: Điều hướng đến màn hình Thư viện
        break;
      case 2:
        // Khám phá
        // TODO: Điều hướng đến màn hình Khám phá
        break;
      case 3:
        // Thông báo
        // TODO: Điều hướng đến màn hình Thông báo
        break;
    }
  }
}
