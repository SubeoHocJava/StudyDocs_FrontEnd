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
import 'package:studydocs/core/widgets/feat/document/information/domain/repository/review_repository.dart' as info_review;
import 'package:studydocs/core/widgets/feat/document/comment/domain/repository/review_repository.dart' as comment_review;
import 'package:studydocs/core/widgets/feat/document/information/domain/entity/document_info.dart';
import 'package:studydocs/core/widgets/feat/document/information/domain/entity/author_info.dart';
import 'package:studydocs/core/widgets/feat/document/information/domain/entity/school_info.dart' as info_school;
import 'package:studydocs/core/widgets/feat/document/overview/domain/entity/document_overview.dart';
import 'package:studydocs/core/widgets/feat/document/overview/domain/entity/course_info.dart';
import 'package:studydocs/core/widgets/feat/document/overview/domain/entity/school_info.dart' as overview_school;

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
          create: (_) => DocumentDetailBloc(
            repository: DocumentDetailRepositoryImpl(dataSource),
          )..add(DocumentDetailRequested(widget.documentId)),
        ),
        BlocProvider(
          create: (_) => DocumentOverviewBloc(
            documentRepository: DocumentRepositoryImpl(),
            libraryRepository: LibraryRepositoryImpl(),
          ),
        ),
        BlocProvider(
          create: (_) => DocumentInformationBloc(
            info_review.ReviewRepositoryImpl(dataSource: dataSource),
          ),
        ),
        BlocProvider(
          create: (_) => DocumentCommentBloc(
            reviewRepository: comment_review.ReviewRepositoryImpl(),
            documentId: widget.documentId,
          )..add(LoadCommentsRequested(widget.documentId)),
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
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
                    schoolInfo: overview_school.SchoolInfo(id: '', name: data.schoolName),
                    courseInfo: CourseInfo(id: '', name: data.categoryName),
                    isSaved: data.isBookmarked,
                  ),
                ),
              );

              // Initialize Information Bloc
              context.read<DocumentInformationBloc>().add(
                DocumentInformationDataReceived(
                  documentInfo: DocumentInfo(
                    id: data.id,
                    startYear: int.tryParse(data.year.split('-').first.trim()) ?? 2024,
                    endYear: int.tryParse(data.year.split('-').last.trim()) ?? 2025,
                    pageNumber: data.pageCount,
                    likeCount: data.likeCount,
                    dislikeCount: data.dislikeCount,
                    isLiked: data.isLiked,
                    isDisliked: data.isDisliked,
                    author: AuthorInfo(
                      id: data.authorId,
                      fullName: data.authorName,
                      avatarUrl: data.authorAvatar,
                      school: info_school.SchoolInfo(name: data.authorSchoolName),
                    ),
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is DocumentDetailLoading || state is DocumentDetailInitial) {
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
                        color: AppColors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: const DocumentInformationPresentation(),
                      ),
                      
                    const SizedBox(height: 16),
                    
                    // Document Preview (Mock image for now)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: state.data.thumbnail != null && state.data.thumbnail!.isNotEmpty
                            ? Image.network(
                                state.data.thumbnail!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                errorBuilder: (_, __, ___) => _buildMockPdfPreview(),
                              )
                            : _buildMockPdfPreview(),
                      ),
                    ),

                    const SizedBox(height: 16),
                    
                    // Comments Block
                    DocumentCommentPresentation(
                      documentId: widget.documentId,
                    ),
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

  Widget _buildMockPdfPreview() {
    return Container(
      width: double.infinity,
      height: 400,
      color: Colors.white,
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Text('BỘ GIÁO DỤC VÀ ĐÀO TẠO', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'Montserrat')),
          Text('TRƯỜNG ĐẠI HỌC NÔNG LÂM TP HCM', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'Montserrat')),
          SizedBox(height: 40),
          Icon(Icons.school, size: 80, color: Colors.green),
          SizedBox(height: 40),
          Text('ĐỒ ÁN CHUYÊN NGÀNH', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, fontFamily: 'Montserrat')),
          SizedBox(height: 16),
          Text('Môn học: Lập trình .NET', style: TextStyle(fontSize: 16, fontFamily: 'Montserrat')),
          SizedBox(height: 40),
          Text('TRANG WEB BÁN RƯỢU', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.red, fontFamily: 'Montserrat')),
        ],
      ),
    );
  }
}
