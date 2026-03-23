import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/constants/app_colors.dart';

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

class DocumentScreen extends StatefulWidget {
  final String documentId;

  const DocumentScreen({super.key, required this.documentId});

  @override
  State<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  bool _isExpanded = false;

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

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
                ..add(GetDocumentRequested(documentId: widget.documentId)),
      child: BlocBuilder<DocumentBloc, DocumentState>(
        builder: (context, state) {
          if (state is DocumentLoaded) {
            final documentId = state.document.id;
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
                      )..add(LoadCommentsRequested(documentId)),
                ),
              ],
              child: Scaffold(
                backgroundColor: AppColors.white,
                body: SafeArea(
                  child: Column(
                    children: [
                      DocumentOverviewPresentation(
                        isExpanded: _isExpanded,
                        onToggle: _toggleExpand,
                      ),
                      const Divider(color: AppColors.divider, thickness: 1, height: 1),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              if (_isExpanded) ...[
                                const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: DocumentInformationPresentation(),
                                ),
                                const Divider(color: AppColors.divider, thickness: 1, height: 1),
                              ],
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Container(
                                  height: 500,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: AppColors.border),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "Document Preview Component\n(To be implemented)",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: AppColors.gray),
                                    ),
                                  ),
                                ),
                              ),
                              const Divider(color: AppColors.divider, thickness: 1, height: 1),
                              DocumentCommentPresentation(
                                documentId: documentId,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    );
  }
}
