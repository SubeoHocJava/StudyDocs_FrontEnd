import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/widgets/feat/document/docs_card/domain/repository/document_repository.dart';
import 'package:studydocs/core/widgets/feat/document/docs_card/domain/usecase/bookmark_document_usecase.dart';
import 'package:studydocs/core/widgets/feat/document/docs_card/domain/usecase/download_document_usecase.dart';
import 'package:studydocs/core/widgets/feat/document/docs_card/domain/usecase/like_document_usecase.dart';
import 'package:studydocs/core/widgets/feat/document/docs_card/logic/docs_card_item_bloc.dart';
import 'package:studydocs/core/widgets/feat/document/docs_card/logic/docs_card_item_event.dart';
import 'package:studydocs/core/widgets/feat/document/docs_card/logic/docs_card_item_state.dart';
import 'package:studydocs/data/model/document_model/response/document_summary_model.dart';
import 'package:studydocs/screens/auth/presentation/cubit/auth_cubit.dart';
import 'package:studydocs/screens/auth/presentation/cubit/auth_state.dart';
import 'package:studydocs/screens/auth/presentation/widgets/auth_dialog.dart';
import 'package:studydocs/core/widgets/feat/document/docs_card/logic/document_sync_cubit.dart' as studydocs_sync_cubit;

import 'home_document_card.dart';

class HomeDocumentCardWithBloc extends StatelessWidget {
  final DocumentSummaryModel doc;
  final DocumentRepository repository;
  final VoidCallback? onTap;

  const HomeDocumentCardWithBloc({
    super.key,
    required this.doc,
    required this.repository,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DocsCardItemBloc(
        likeUseCase: LikeDocumentUseCaseImpl(repository),
        bookmarkUseCase: BookmarkDocumentUseCaseImpl(repository),
        downloadUseCase: DownloadDocumentUseCaseImpl(repository),
        initialDoc: doc,
        syncCubit: context.read<studydocs_sync_cubit.DocumentSyncCubit>(),
      ),
      child: _HomeCardBody(onTap: onTap),
    );
  }
}

class _HomeCardBody extends StatelessWidget {
  final VoidCallback? onTap;

  const _HomeCardBody({this.onTap});

  @override
  Widget build(BuildContext context) {
    return BlocListener<DocsCardItemBloc, DocsCardItemState>(
      listenWhen: (previous, current) => current.lastError != null,
      listener: (context, state) {
        final error = state.lastError;
        if (error == null) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error)),
        );
        context.read<DocsCardItemBloc>().clearError();
      },
      child: BlocBuilder<DocsCardItemBloc, DocsCardItemState>(
        builder: (context, state) {
          final bloc = context.read<DocsCardItemBloc>();
          
          void performAction(VoidCallback action) {
            final authState = context.read<AuthCubit>().state;
            if (authState is! AuthAuthenticated) {
              showAuthDialog(context);
            } else {
              action();
            }
          }

          return HomeDocumentCard(
            doc: state.doc,
            onLike: () => performAction(() => bloc.add(const CardLiked())),
            onBookmark: () => performAction(() => bloc.add(const CardBookmarked())),
            onDownload: () => performAction(() => bloc.add(const CardDownloaded())),
            onTap: onTap,
          );
        },
      ),
    );
  }
}
