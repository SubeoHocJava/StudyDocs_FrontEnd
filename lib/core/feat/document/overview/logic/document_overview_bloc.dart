import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/feat/document/overview/domain/repository/document_repository.dart';
import 'package:studydocs/core/feat/document/overview/domain/usecase/download_usecase.dart';
import 'package:studydocs/core/feat/document/overview/domain/usecase/save_usecase.dart';
import 'package:studydocs/core/feat/document/overview/domain/usecase/unsave_usecase.dart';
import 'package:studydocs/core/feat/document/overview/domain/repository/library_repository.dart';

import 'document_overview_event.dart';
import 'document_overview_state.dart';

class DocumentOverviewBloc
    extends Bloc<DocumentOverviewEvent, DocumentOverviewState> {
  final DocumentRepository _documentRepository;
  final LibraryRepository _libraryRepository;

  DocumentOverviewBloc({
    required DocumentRepository documentRepository,
    required LibraryRepository libraryRepository,
  }) : _documentRepository = documentRepository,
       _libraryRepository = libraryRepository,
       super(DocumentOverviewInitial()) {
    final SaveUseCase saveUseCase = SaveUseCaseImpl(_libraryRepository);
    final UnSaveUseCase unSaveUseCase = UnSaveUseCaseImpl(_libraryRepository);
    final DownloadUseCase downloadUseCase = DownloadUseCaseImpl(
      _documentRepository,
    );

    on<DocumentOverviewDataReceived>((event, emit) {
      emit(DocumentOverviewLoaded(documentOverview: event.documentOverview));
    });

    on<DocumentSave>((event, emit) async {
      final current = state as DocumentOverviewLoaded;
      emit(
        DocumentOverviewLoaded(
          documentOverview: current.documentOverview.copyWith(isSaved: true),
        ),
      );
      try {
        await saveUseCase.call(event.id);
      } catch (e) {
        emit(
          DocumentOverviewLoaded(
            documentOverview: current.documentOverview.copyWith(isSaved: false),
          ),
        );
      }
    });

    on<DocumentUnSave>((event, emit) async {
      final current = state as DocumentOverviewLoaded;
      emit(
        DocumentOverviewLoaded(
          documentOverview: current.documentOverview.copyWith(isSaved: false),
        ),
      );
      try {
        await unSaveUseCase.call(event.id);
      } catch (e) {
        emit(
          DocumentOverviewLoaded(
            documentOverview: current.documentOverview.copyWith(isSaved: true),
          ),
        );
      }
    });

    on<DocumentDownloadRequested>((event, emit) async {
      final current = state as DocumentOverviewLoaded;
      final downloadUrl = await downloadUseCase.call(event.id);
      emit(
        DocumentOverviewLoaded(
          documentOverview: current.documentOverview,
          downloadUrl: downloadUrl,
        ),
      );
    });
    on<SchoolClicked>((event, emit) {
      // TODO: Handle school clicked
    });
    on<CourseClicked>((event, emit) {
      // TODO: Handle course clicked
    });
  }
}
