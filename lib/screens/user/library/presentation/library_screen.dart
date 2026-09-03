import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';
import 'package:studydocs/core/constants/app_colors.dart';
import 'package:studydocs/core/widgets/feat/common/folder_list/presentation/folder_list_vertical_with_bloc.dart';
import 'package:studydocs/core/widgets/feat/document/docs_card/domain/repository/document_repository.dart';
import 'package:studydocs/core/widgets/feat/document/docs_card/presentation/document_card_horizontal_with_bloc.dart';
import 'package:studydocs/core/widgets/feat/document/docs_card/presentation/document_card_square_carousel.dart';
import 'package:studydocs/core/widgets/feat/document/upload/presentation/upload_dropzone_tile.dart';
import 'package:studydocs/screens/user/library/data/repository/library_repository_impl.dart';
import 'package:studydocs/data/datasource/impl/document_remote_datasource_impl.dart';

import 'package:studydocs/screens/user/library/logic/library_bloc.dart';
import 'package:studydocs/screens/user/library/logic/library_event.dart';
import 'package:studydocs/screens/user/library/logic/library_state.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dataSource = DocumentRemoteDataSourceImpl();
    final repository = LibraryRepositoryImpl(dataSource);

    return BlocProvider(
      create: (_) => LibraryBloc(
        repository: repository,
      )..add(const LibraryRequested()),
      child: _LibraryView(documentRepository: repository),
    );
  }
}

class _LibraryView extends StatelessWidget {
  final DocumentRepository documentRepository;

  const _LibraryView({
    required this.documentRepository,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LibraryBloc, LibraryState>(
      builder: (context, state) {
        if (state is LibraryLoading || state is LibraryInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is LibraryFailure) {
          return _ErrorState(message: state.message);
        }

        if (state is! LibraryLoaded) {
          return const SizedBox.shrink();
        }

        final data = state.data;
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(32, 16, 32, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: UploadDropzoneTile(
                      onTap: () async {
                        try {
                          final result = await FilePicker.platform.pickFiles(withData: true);
                          if (result != null && result.files.isNotEmpty) {
                            if (context.mounted) {
                              context.push('/upload', extra: result.files.single);
                            }
                          }
                        } catch (e) {
                          debugPrint('Error picking file: $e');
                        }
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const _SectionTitle('Môn học'),
              const SizedBox(height: 8),
              FolderListVerticalWithBloc(
                items: data.subjects,
                initialSelectedId:
                    data.subjects.isNotEmpty ? data.subjects.first.id : null,
                padding: EdgeInsets.zero,
                onSelected: (subjectId) => context.go('/library/$subjectId'),
              ),
              const SizedBox(height: 16),
              const _SectionTitle('Tài liệu gần đây'),
              const SizedBox(height: 8),
              if (data.recentDocuments.isEmpty)
                const _EmptyState('Chưa có tài liệu gần đây')
              else
                DocumentCardSquareCarousel(
                  docs: data.recentDocuments,
                  itemSize: 100,
                  padding: EdgeInsets.zero,
                ),
              const SizedBox(height: 16),
              const _SectionTitle('Tài liệu lưu trữ'),
              const SizedBox(height: 8),
              if (data.savedDocuments.isEmpty)
                const _EmptyState('Chưa có tài liệu lưu trữ')
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: data.savedDocuments.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final doc = data.savedDocuments[index];
                    return SizedBox(
                      height: 150,
                      child: DocumentCardHorizontalWithBloc(
                        doc: doc,
                        repository: documentRepository,
                      ),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String text;

  const _EmptyState(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: AppColors.gray,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppColors.black,
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;

  const _ErrorState({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          'Không tải được thư viện.\n$message',
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.black),
        ),
      ),
    );
  }
}
