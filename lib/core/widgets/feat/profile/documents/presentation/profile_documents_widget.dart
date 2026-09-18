import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/widgets/feat/document/docs_card/presentation/document_card_horizontal_with_bloc.dart';
import 'package:studydocs/data/datasource/impl/document_remote_datasource_impl.dart';
import 'package:studydocs/screens/home/data/repository/home_repository_impl.dart';

import '../logic/profile_documents_bloc.dart';
import '../logic/profile_documents_state.dart';

class ProfileDocumentsWidget extends StatelessWidget {
  const ProfileDocumentsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final docRepository = HomeRepositoryImpl(DocumentRemoteDataSourceImpl());

    return BlocBuilder<ProfileDocumentsBloc, ProfileDocumentsState>(
      builder: (context, state) {
        if (state is ProfileDocumentsLoading || state is ProfileDocumentsInitial) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is ProfileDocumentsError) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Center(child: Text("Lỗi tải tài liệu: ${state.message}")),
          );
        }

        if (state is ProfileDocumentsLoaded) {
          if (state.documents.isEmpty) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: Text("Người dùng này chưa đăng tải tài liệu nào.")),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
                child: Text(
                  'Tài liệu đã đăng tải',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: state.documents.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final doc = state.documents[index];
                  return SizedBox(
                    height: 150,
                    child: DocumentCardHorizontalWithBloc(
                      doc: doc,
                      repository: docRepository,
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
