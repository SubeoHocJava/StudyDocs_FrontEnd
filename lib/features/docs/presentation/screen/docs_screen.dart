import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/docs_bloc.dart';
import '../../logic/docs_state.dart';
import '../doc_cctions.dart';
import '../doc_header.dart';
import '../docInfo_row.dart';
import 'docs_detail_screen.dart';
import '../PdfPreview.dart';
import '../../../../core/constants/app_icons.dart';

class DocsScreen extends StatelessWidget {
  const DocsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<DocsBloc, DocsState>(
          builder: (context, state) {
            if (state is DocsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DocsLoaded) {
              final doc = state.docDetails;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DocHeader(
                      title: doc["title"],
                      isDetail: false,
                      onTapArrow: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: BlocProvider.of<DocsBloc>(context),
                              child: const DocsDetailScreen(),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    DocInfoRow(text: doc["course"], iconPath: AppAssets.folder),
                    const SizedBox(height: 6),
                    DocInfoRow(text: doc["school"], iconPath: AppAssets.school),
                    const SizedBox(height: 16),
                    DocActions(state: state),
                    const SizedBox(height: 20),
                    PdfPreview(height: 250, label: "PDF Preview nhỏ ở đây"),
                  ],
                ),
              );
            } else if (state is DocsError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
