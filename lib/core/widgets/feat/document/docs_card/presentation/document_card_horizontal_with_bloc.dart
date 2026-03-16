import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/widgets/feat/document/docs_card/domain/repository/document_repository.dart';
import 'package:studydocs/core/widgets/feat/document/docs_card/domain/usecase/bookmark_document_usecase.dart';
import 'package:studydocs/core/widgets/feat/document/docs_card/domain/usecase/download_document_usecase.dart';
import 'package:studydocs/core/widgets/feat/document/docs_card/domain/usecase/like_document_usecase.dart';
import 'package:studydocs/core/widgets/feat/document/docs_card/logic/docs_card_item_bloc.dart';
import 'package:studydocs/core/widgets/feat/document/docs_card/logic/docs_card_item_event.dart';
import 'package:studydocs/core/widgets/feat/document/docs_card/logic/docs_card_item_state.dart';
import 'package:studydocs/core/widgets/feat/document/docs_card/presentation/document_card_horizontal.dart';
import 'package:studydocs/data/model/document_model/response/document_summary_model.dart';

/// Widget gom Bloc cho 1 card — trang tự build list và tự set size từng card.
/// Trang chỉ cần: DocumentCardHorizontalWithBloc(doc: doc, repository: repo).
/// UseCase được tạo từ repository bên trong widget (domain tách rõ như comment).
class DocumentCardHorizontalWithBloc extends StatelessWidget {
  final DocumentSummaryModel doc;
  final DocumentRepository repository;
  final VoidCallback? onTap;

  const DocumentCardHorizontalWithBloc({
    super.key,
    required this.doc,
    required this.repository,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final likeUseCase = LikeDocumentUseCaseImpl(repository);
    final bookmarkUseCase = BookmarkDocumentUseCaseImpl(repository);
    final downloadUseCase = DownloadDocumentUseCaseImpl(repository);
    return BlocProvider(
      create: (_) => DocsCardItemBloc(
        likeUseCase: likeUseCase,
        bookmarkUseCase: bookmarkUseCase,
        downloadUseCase: downloadUseCase,
        initialDoc: doc,
      ),
      child: _CardWithBlocBody(onTap: onTap),
    );
  }
}

class _CardWithBlocBody extends StatelessWidget {
  final VoidCallback? onTap;

  const _CardWithBlocBody({this.onTap});

  @override
  Widget build(BuildContext context) {
    return BlocListener<DocsCardItemBloc, DocsCardItemState>(
      listenWhen: (prev, curr) => curr.lastError != null,
      listener: (context, state) {
        if (state.lastError != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.lastError!)),
          );
          context.read<DocsCardItemBloc>().clearError();
        }
      },
      child: BlocBuilder<DocsCardItemBloc, DocsCardItemState>(
        builder: (context, state) {
          final bloc = context.read<DocsCardItemBloc>();
          return DocumentCardHorizontal(
            doc: state.doc,
            onLike: () => bloc.add(const CardLiked()),
            onBookmark: () => bloc.add(const CardBookmarked()),
            onDownload: () => bloc.add(const CardDownloaded()),
            onTap: onTap,
          );
        },
      ),
    );
  }
}
