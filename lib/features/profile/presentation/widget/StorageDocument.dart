import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/features/docs/data/model/document_model.dart';
import 'package:studydocs/core/widgets/document/model/list_document_ui.dart';

import '../../../../core/widgets/document/ListDocument.dart';
import 'package:studydocs/features/docs/data/model/document_model.dart';
import '../../domain/model/document_profile.dart';
import '../../logic/profile_bloc.dart';
import '../../logic/profile_event.dart';
import '../../logic/profile_state.dart';

class StorageDocument extends StatelessWidget {
  final ProfileLoaded state;

  const StorageDocument({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    List<DocumentProfile> documents = state.documents;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            "Danh sách tài liệu",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        ListDocument(
          documents.cast<DocumentUiList>(),
          onDownload: (doc) {
            context.read<ProfileBloc>().add(DownloadDocumentRequested(doc.id));
          },
          onSave: (doc) {
            context.read<ProfileBloc>().add(SaveDocumentRequested(doc.id));
          },
          onLike: (doc) {
            context.read<ProfileBloc>().add(LikeDocumentRequested(doc.id));
          },
          onComment: (doc) {
            context.read<ProfileBloc>().add(OpenCommentRequested(doc.id));
          },
        ),
      ],
    );
  }
}
