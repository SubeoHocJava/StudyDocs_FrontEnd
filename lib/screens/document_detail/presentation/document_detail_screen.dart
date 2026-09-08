import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/constants/app_colors.dart';
import 'package:studydocs/core/widgets/feat/document/comment/logic/document_comment_bloc.dart';
import 'package:studydocs/core/widgets/feat/document/comment/logic/document_comment_event.dart';
import 'package:studydocs/core/widgets/feat/document/comment/presentation/document_comment_presentation.dart';
import 'package:studydocs/core/widgets/feat/document/information/logic/document_information_bloc.dart';
import 'package:studydocs/core/widgets/feat/document/information/logic/document_information_event.dart';
import 'package:studydocs/core/widgets/feat/document/information/presentation/document_information_presentation.dart';
import 'package:studydocs/core/widgets/feat/document/overview/logic/document_overview_bloc.dart';
import 'package:studydocs/core/widgets/feat/document/overview/logic/document_overview_event.dart';
import 'package:studydocs/core/widgets/feat/document/overview/presentation/document_overview_presentation.dart';
import 'package:studydocs/screens/document_detail/logic/document_detail_bloc.dart';
import 'package:studydocs/screens/document_detail/logic/document_detail_event.dart';
import 'package:studydocs/screens/document_detail/logic/document_detail_state.dart';
import 'package:studydocs/data/datasource/impl/document_remote_datasource_impl.dart';
import 'package:studydocs/screens/document_detail/data/repository/document_detail_repository_impl.dart';
import 'package:studydocs/core/widgets/feat/document/overview/domain/repository/document_repository.dart';
import 'package:studydocs/core/widgets/feat/document/overview/domain/repository/library_repository.dart';
import 'package:studydocs/core/widgets/feat/document/information/domain/repository/review_repository.dart'
    as info_review;
import 'package:studydocs/core/widgets/feat/document/comment/domain/repository/review_repository.dart'
    as comment_review;
import 'package:studydocs/core/widgets/feat/document/information/domain/entity/document_info.dart';
import 'package:studydocs/core/widgets/feat/document/information/domain/entity/author_info.dart';
import 'package:studydocs/core/widgets/feat/document/information/domain/entity/school_info.dart'
    as info_school;
import 'package:studydocs/core/widgets/feat/document/overview/domain/entity/document_overview.dart';
import 'package:studydocs/core/widgets/feat/document/overview/domain/entity/course_info.dart';
import 'package:studydocs/core/widgets/feat/document/overview/domain/entity/school_info.dart'
    as overview_school;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:studydocs/core/utils/image_utils.dart';
import 'package:studydocs/screens/document_detail/domain/entity/document_detail_data.dart';
import 'package:studydocs/core/constants/api_constants.dart';

class DocumentDetailScreen extends StatefulWidget {
  final String documentId;

  const DocumentDetailScreen({super.key, required this.documentId});

  @override
  State<DocumentDetailScreen> createState() => _DocumentDetailScreenState();
}

class _DocumentDetailScreenState extends State<DocumentDetailScreen> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    final dataSource = DocumentRemoteDataSourceImpl();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (_) => DocumentDetailBloc(
                repository: DocumentDetailRepositoryImpl(dataSource),
              )..add(DocumentDetailRequested(widget.documentId)),
        ),
        BlocProvider(
          create:
              (_) => DocumentOverviewBloc(
                documentRepository: DocumentRepositoryImpl(),
                libraryRepository: LibraryRepositoryImpl(),
              ),
        ),
        BlocProvider(
          create:
              (_) => DocumentInformationBloc(
                info_review.ReviewRepositoryImpl(dataSource: dataSource),
              ),
        ),
        BlocProvider(
          create:
              (_) => DocumentCommentBloc(
                reviewRepository: comment_review.ReviewRepositoryImpl(),
                documentId: widget.documentId,
              )..add(LoadCommentsRequested(widget.documentId)),
        ),
      ],
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: BlocConsumer<DocumentDetailBloc, DocumentDetailState>(
          listener: (context, state) {
            if (state is DocumentDetailLoaded) {
              final data = state.data;
              // Initialize Overview Bloc
              context.read<DocumentOverviewBloc>().add(
                DocumentOverviewDataReceived(
                  documentOverview: DocumentOverview(
                    id: data.id,
                    title: data.title,
                    schoolInfo: overview_school.SchoolInfo(
                      id: '',
                      name: data.schoolName,
                    ),
                    courseInfo: CourseInfo(id: '', name: data.categoryName),
                    isSaved: data.isBookmarked,
                    fileUrl: data.fileUrl,
                  ),
                ),
              );

              // Initialize Information Bloc
              context.read<DocumentInformationBloc>().add(
                DocumentInformationDataReceived(
                  documentInfo: DocumentInfo(
                    id: data.id,
                    startYear:
                        int.tryParse(data.year.split('-').first.trim()) ?? 2024,
                    endYear:
                        int.tryParse(data.year.split('-').last.trim()) ?? 2025,
                    pageNumber: data.pageCount,
                    likeCount: data.likeCount,
                    dislikeCount: data.dislikeCount,
                    isLiked: data.isLiked,
                    isDisliked: data.isDisliked,
                    author: AuthorInfo(
                      id: data.authorId,
                      fullName: data.authorName,
                      avatarUrl: data.authorAvatar,
                      school: info_school.SchoolInfo(
                        name: data.authorSchoolName,
                      ),
                    ),
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is DocumentDetailLoading ||
                state is DocumentDetailInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is DocumentDetailError) {
              return Center(child: Text('Lỗi: ${state.message}'));
            }

            if (state is DocumentDetailLoaded) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    // Overview Block (Header)
                    DocumentOverviewPresentation(
                      isExpanded: _isExpanded,
                      onToggle: () {
                        setState(() {
                          _isExpanded = !_isExpanded;
                        });
                      },
                    ),

                    // Information Block (Collapsible)
                    if (_isExpanded)
                      Container(
                        color: Theme.of(context).cardColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: const DocumentInformationPresentation(),
                      ),

                    const SizedBox(height: 16),

                    // Document Preview
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: _buildDocumentPreview(state.data),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Comments Block
                    DocumentCommentPresentation(documentId: widget.documentId),
                    const SizedBox(height: 32),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildDocumentPreview(DocumentDetailData data) {
    String fileUrl = data.fileUrl;
    String? thumbnail = data.thumbnail;
    int pageCount = data.pageCount > 0 ? data.pageCount : 1;

    bool isPdf = data.fileType.toLowerCase().contains('pdf') || fileUrl.toLowerCase().endsWith('.pdf');

    if (isPdf) {
      String pdfUrl = fileUrl;
      if (pdfUrl.startsWith('http://') && pdfUrl.contains('cloudinary.com')) {
        pdfUrl = pdfUrl.replaceFirst('http://', 'https://');
      } else if (pdfUrl.startsWith('/')) {
        final baseUrl = ApiConstants.baseUrl.replaceAll(RegExp(r'/+$'), '');
        pdfUrl = '$baseUrl$pdfUrl';
      } else if (!pdfUrl.startsWith('http')) {
        pdfUrl = '${ApiConstants.baseUrl}$pdfUrl';
      }

      return SizedBox(
        width: double.infinity,
        height: 600,
        child: SfPdfViewer.network(
          pdfUrl,
          canShowScrollHead: false,
          canShowScrollStatus: false,
        ),
      );
    }

    // Use page template if provided by BE
    if (thumbnail != null && thumbnail.contains('<<pageNumber>>')) {
      return SizedBox(
        height: 600,
        child: ListView.builder(
          itemCount: pageCount,
          itemBuilder: (context, index) {
            String pageUrl = ImageUtils.getPagePreview(thumbnail, index + 1)!;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Image.network(
                pageUrl,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => _buildMockPreview(),
              ),
            );
          },
        ),
      );
    }

    // Fallback sang thumbnail image (ImageUtils)
    String? thumb = ImageUtils.getPagePreview(thumbnail ?? fileUrl, 1);
    if (thumb != null && thumb.isNotEmpty) {
      return Image.network(
        thumb,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (_, __, ___) => _buildMockPreview(),
      );
    }

    return _buildMockPreview();
  }

  Widget _buildMockPreview() {
    return Container(
      width: double.infinity,
      height: 400,
      color: Theme.of(context).cardColor,
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.description_outlined, size: 80, color: AppColors.grey),
          SizedBox(height: 16),
          Text(
            'Không thể xem trước tài liệu này',
            style: TextStyle(fontSize: 16, color: AppColors.grey),
          ),
        ],
      ),
    );
  }
}
