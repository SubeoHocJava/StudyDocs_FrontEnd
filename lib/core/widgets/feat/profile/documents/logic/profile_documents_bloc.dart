import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/screens/profile/domain/repository/profile_document_repository.dart';
import 'profile_documents_event.dart';
import 'profile_documents_state.dart';

class ProfileDocumentsBloc extends Bloc<ProfileDocumentsEvent, ProfileDocumentsState> {
  final ProfileDocumentRepository repository;

  ProfileDocumentsBloc({required this.repository}) : super(ProfileDocumentsInitial()) {
    on<FetchProfileDocumentsEvent>(_onFetchProfileDocuments);
  }

  Future<void> _onFetchProfileDocuments(
      FetchProfileDocumentsEvent event, Emitter<ProfileDocumentsState> emit) async {
    emit(ProfileDocumentsLoading());
    try {
      final documents = await repository.getUserDocuments(event.userId);
      emit(ProfileDocumentsLoaded(documents));
    } catch (e) {
      emit(ProfileDocumentsError(e.toString()));
    }
  }
}
