import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/widgets/feat/document/comment/domain/repository/review_repository.dart'
    as comment_review_repository;
import 'package:studydocs/core/widgets/feat/document/comment/presentation/document_comment_presentation.dart';
import 'package:studydocs/core/widgets/feat/document/information/domain/repository/review_repository.dart'
    as information_review_repository;
import 'package:studydocs/core/widgets/feat/document/comment/logic/document_comment_bloc.dart';
import 'package:studydocs/core/widgets/feat/document/information/logic/document_information_bloc.dart';
import 'package:studydocs/core/widgets/feat/document/information/presentation/document_information_presentation.dart';
import 'package:studydocs/core/widgets/feat/document/overview/domain/repository/document_repository.dart';
import 'package:studydocs/core/widgets/feat/document/overview/domain/repository/library_repository.dart';
import 'package:studydocs/core/widgets/feat/document/overview/logic/document_overview_bloc.dart';
import 'package:studydocs/core/widgets/feat/document/overview/presentation/document_overview_presentation.dart';

class DocumentScreen extends StatelessWidget {
  const DocumentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) => DocumentOverviewBloc(
                documentRepository: DocumentRepositoryImpl(),
                libraryRepository: LibraryRepositoryImpl(),
              ),
        ),
        BlocProvider(
          create:
              (context) => DocumentInformationBloc(
                information_review_repository.ReviewRepositoryImpl(),
              ),
        ),
        BlocProvider(
          create:
              (context) => DocumentCommentBloc(
                reviewRepository:
                    comment_review_repository.ReviewRepositoryImpl(),
                documentId: "",
              ),
        ),
      ],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DocumentOverviewPresentation(),
          DocumentInformationPresentation(),
          DocumentCommentPresentation(documentId: ""),
        ],
      ),
    );
  }
}
