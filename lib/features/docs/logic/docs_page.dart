import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repository/impl/docs_repository_impl.dart';
import '../domain/usecase/get_document_usecase.dart';
import '../domain/usecase/toggle_save_usecase.dart';
import 'docs_bloc.dart';
import 'docs_event.dart';
import '../presentation/screen/docs_screen.dart';

/// Inject Repository + UseCases + BLoC
/// Khởi tạo LoadDocDetails ngay khi mở page
class DocsPage extends StatelessWidget {
  const DocsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = DocsRepositoryImpl();

    return BlocProvider(
      create: (_) => DocsBloc(
        getDocumentUseCase: GetDocumentUseCase(repository),
        toggleSaveUseCase: ToggleSaveUseCase(repository),
      )..add(LoadDocDetails()), // load ngay khi mở
      child: const DocsScreen(),
    );
  }
}
