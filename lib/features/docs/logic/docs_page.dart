import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/datasource/docs_remote_datasource.dart';
import '../domain/repository/impl/docs_repository_impl.dart';
import '../domain/usecase/get_document_usecase.dart';
import '../domain/usecase/toggle_save_usecase.dart';
import '../presentation/screen/docs_screen.dart';
import 'docs_bloc.dart';
import 'docs_event.dart';
import '../../../../core/network/dio_client.dart';

class DocsPage extends StatelessWidget {
  const DocsPage({super.key});

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
      )..add(LoadDocDetails()), // load ngay khi mở
      child: const DocsScreen(),
    );
  }
}