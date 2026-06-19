import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/constants/app_colors.dart';
import 'package:studydocs/core/widgets/feat/document/docs_card/domain/repository/document_repository.dart';
import 'package:studydocs/core/widgets/feat/document/docs_card/presentation/document_card_horizontal_with_bloc.dart';
import 'package:studydocs/core/widgets/feat/document/docs_card/presentation/document_card_square_carousel.dart';
import 'package:studydocs/core/widgets/feat/document/explore/presentation/explore_header_with_bloc.dart';
import 'package:studydocs/data/datasource/impl/library_remote_repository.dart';
import 'package:studydocs/screens/user/library/domain/usecase/get_library_subject_page_usecase.dart';
import 'package:studydocs/screens/user/library/logic/library_subject_bloc.dart';
import 'package:studydocs/screens/user/library/logic/library_subject_event.dart';
import 'package:studydocs/screens/user/library/logic/library_subject_state.dart';

class LibrarySubjectScreen extends StatelessWidget {
  final String subjectId;

  const LibrarySubjectScreen({
    super.key,
    required this.subjectId,
  });

  @override
  Widget build(BuildContext context) {
    final repository = LibraryRemoteRepository();

    return BlocProvider(
      create: (_) => LibrarySubjectBloc(
        getLibrarySubjectPageUseCase:
            GetLibrarySubjectPageUseCaseImpl(repository),
      )..add(LibrarySubjectRequested(subjectId)),
      child: _LibrarySubjectView(documentRepository: repository),
    );
  }
}

class _LibrarySubjectView extends StatelessWidget {
  final DocumentRepository documentRepository;

  const _LibrarySubjectView({
    required this.documentRepository,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LibrarySubjectBloc, LibrarySubjectState>(
      builder: (context, state) {
        if (state is LibrarySubjectLoading || state is LibrarySubjectInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is LibrarySubjectFailure) {
          return _SubjectErrorState(message: state.message);
        }

        if (state is! LibrarySubjectLoaded) {
          return const SizedBox.shrink();
        }

        final data = state.data;
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(32, 16, 32, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExploreHeaderWithBloc(
                initialSchoolName: data.schoolName,
                initialSubjectName: data.subjectName,
                initialDocumentCount: data.documentCount,
                initialUserCount: data.userCount,
              ),
              const SizedBox(height: 14),
              const _SubjectSectionTitle('Tài liệu bạn tải lên'),
              const SizedBox(height: 8),
              DocumentCardSquareCarousel(
                docs: data.uploadedDocuments,
                itemSize: 100,
                padding: EdgeInsets.zero,
              ),
              const SizedBox(height: 14),
              const _SubjectSectionTitle('Lượt thích cao nhất'),
              const SizedBox(height: 8),
              DocumentCardSquareCarousel(
                docs: data.topLikedDocuments,
                itemSize: 100,
                padding: EdgeInsets.zero,
              ),
              const SizedBox(height: 14),
              const _SubjectSectionTitle('Tài liệu lưu trữ'),
              const SizedBox(height: 8),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: data.storedDocuments.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final doc = data.storedDocuments[index];
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

class _SubjectSectionTitle extends StatelessWidget {
  final String text;

  const _SubjectSectionTitle(this.text);

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

class _SubjectErrorState extends StatelessWidget {
  final String message;

  const _SubjectErrorState({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          'Không tải được môn học.\n$message',
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.black),
        ),
      ),
    );
  }
}
