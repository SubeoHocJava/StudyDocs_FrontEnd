import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/data/datasource/docs_remote_datasource.dart';
import 'package:studydocs/features/docs/data/repository/docs_repository_impl.dart';
import '../domain/usecase/get_document_usecase.dart';
import '../domain/usecase/toggle_like_usecase.dart';
import '../domain/usecase/toggle_save_usecase.dart';
import '../domain/usecase/post_comment_usecase.dart';
import '../domain/usecase/react_review_usecase.dart';
import '../domain/usecase/delete_document_usecase.dart'; 
import '../domain/usecase/update_document_usecase.dart'; 
import '../presentation/screen/docs_screen.dart';
import 'docs_bloc.dart';
import 'docs_event.dart';
import '../../../../core/network/dio_client.dart';

class DocsPage extends StatelessWidget {
  final String documentId;

  const DocsPage({super.key, required this.documentId});

  @override
  Widget build(BuildContext context) {
    // Lấy DioClient từ context
    final dioClient = context.read<DioClient>();
    final dataSource = DocsRemoteDataSourceImpl(dioClient: dioClient);
    final repository = DocsRepositoryImpl(dataSource: dataSource);

    return BlocProvider(
      create: (_) => DocsBloc(
        documentId: documentId,
        getDocumentUseCase: GetDocumentUseCase(repository),
        toggleSaveUseCase: ToggleSaveUseCase(repository),
        toggleLikeUseCase: ToggleLikeUseCase(repository),
        postCommentUseCase: PostCommentUseCase(repository),
        reactReviewUseCase: ReactReviewUseCase(repository),
        deleteDocumentUseCase: DeleteDocumentUseCase(repository: repository),
        updateDocumentUseCase: UpdateDocumentUseCase(repository: repository), // Add injection
      )..add(LoadDocDetails()),
      child: const DocsScreen(),
    );
  }
}