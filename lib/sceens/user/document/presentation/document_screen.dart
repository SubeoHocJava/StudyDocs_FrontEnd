import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:studydocs/core/widgets/feat/document/comment/domain/repository/review_repository.dart'
    as comment_review_repository;
import 'package:studydocs/core/widgets/feat/document/comment/logic/document_comment_bloc.dart';
import 'package:studydocs/core/widgets/feat/document/comment/logic/document_comment_event.dart';
import 'package:studydocs/core/widgets/feat/document/comment/presentation/document_comment_presentation.dart';

import 'package:studydocs/core/widgets/feat/document/information/domain/repository/review_repository.dart'
    as information_review_repository;
import 'package:studydocs/core/widgets/feat/document/information/logic/document_information_bloc.dart';
import 'package:studydocs/core/widgets/feat/document/information/logic/document_information_event.dart';
import 'package:studydocs/core/widgets/feat/document/information/presentation/document_information_presentation.dart';
import 'package:studydocs/core/widgets/feat/document/overview/domain/entity/document_overview.dart';
import 'package:studydocs/core/widgets/feat/document/overview/domain/entity/school_info.dart';

import 'package:studydocs/core/widgets/feat/document/overview/domain/repository/document_repository.dart'
    as document_overview_repository;
import 'package:studydocs/core/widgets/feat/document/overview/logic/document_overview_event.dart';
import 'package:studydocs/sceens/user/document/domain/repository/document_repository.dart'
    as document_repository;
import 'package:studydocs/core/widgets/feat/document/overview/domain/repository/library_repository.dart';
import 'package:studydocs/core/widgets/feat/document/overview/logic/document_overview_bloc.dart';
import 'package:studydocs/core/widgets/feat/document/overview/presentation/document_overview_presentation.dart';
import 'package:studydocs/sceens/user/document/logic/document_bloc.dart';
import 'package:studydocs/sceens/user/document/logic/document_event.dart';
import 'package:studydocs/sceens/user/document/logic/document_state.dart';

class DocumentScreen extends StatelessWidget {
  final String documentId;

  const DocumentScreen({super.key, required this.documentId});

  @override
  Widget build(BuildContext context) {
    final documentRepository = document_repository.DocumentRepositoryImpl();
    final documentOverviewRepository =
        document_overview_repository.DocumentRepositoryImpl();
    final libraryRepository = LibraryRepositoryImpl();

    final informationReviewRepository =
        information_review_repository.ReviewRepositoryImpl();

    final commentReviewRepository =
        comment_review_repository.ReviewRepositoryImpl();

    return BlocProvider(
      create:
          (_) =>
              DocumentBloc(documentRepository: documentRepository)
                ..add(GetDocumentRequested(documentId: documentId)),
      child: BlocBuilder<DocumentBloc, DocumentState>(
        builder: (context, state) {
          final documentId = this.documentId;
          if (state is DocumentLoaded) {
            final document = state.document;
            return MultiBlocProvider(
              providers: [
                BlocProvider<DocumentOverviewBloc>(
                  create:
                      (_) => DocumentOverviewBloc(
                        documentRepository: documentOverviewRepository,
                        libraryRepository: libraryRepository,
                      )..add(
                        DocumentOverviewDataReceived(
                          documentOverview: document.mapToOverview(),
                        ),
                      ),
                ),
                BlocProvider<DocumentInformationBloc>(
                  create:
                      (_) =>
                          DocumentInformationBloc(informationReviewRepository)
                            ..add(
                              DocumentInformationDataReceived(
                                documentInfo: document.mapToInformation(),
                              ),
                            ),
                ),
                BlocProvider<DocumentCommentBloc>(
                  create:
                      (_) => DocumentCommentBloc(
                        reviewRepository: commentReviewRepository,
                        documentId: documentId,
                      )..add(LoadCommentsRequested(this.documentId)),
                ),
              ],
              child: Scaffold(
                body: Column(
                  children: [
                    DocumentOverviewPresentation(),
                    DocumentInformationPresentation(),
                    Expanded(
                      child: DocumentCommentPresentation(
                        documentId: documentId,
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Text("load");
          }
        },
      ),
    );
  }
}
