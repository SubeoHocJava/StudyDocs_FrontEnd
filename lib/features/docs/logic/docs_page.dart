import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/datasource/docs_remote_datasource.dart';
import '../data/repository/docs_repository_impl.dart';
import '../domain/usecase/get_document_usecase.dart';
import '../domain/usecase/toggle_like_usecase.dart';
import '../domain/usecase/toggle_save_usecase.dart';
import '../domain/usecase/post_comment_usecase.dart';
import '../domain/usecase/react_review_usecase.dart';
import '../presentation/screen/docs_screen.dart';
import 'docs_bloc.dart';
import 'docs_event.dart';
import '../../../../core/network/dio_client.dart';

class DocsPage extends StatelessWidget {
  final String documentId;

  const DocsPage({super.key, required this.documentId});

  @override
  Widget build(BuildContext context) {
    // Tạo DataSource (inject Dio nếu có)
    final dioClient = DioClient(); // Giả sử lấy từ Provider hoặc singleton
    final dataSource = DocsRemoteDataSourceImpl(dioClient: dioClient);

    // Tạo RepositoryImpl với DataSource
    final repository = DocsRepositoryImpl(dataSource: dataSource);

    return BlocProvider(
      create: (_) => DocsBloc(
        getDocumentUseCase: GetDocumentUseCase(repository),
        toggleSaveUseCase: ToggleSaveUseCase(repository),
        toggleLikeUseCase: ToggleLikeUseCase(repository),
        postCommentUseCase: PostCommentUseCase(repository),
        reactReviewUseCase: ReactReviewUseCase(repository),
      )..add(LoadDocDetails(documentId)),
      child: const DocsScreen(),
    );
  }
}