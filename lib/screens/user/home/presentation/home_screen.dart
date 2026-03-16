import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:studydocs/core/widgets/feat/common/folder_list/domain/entity/folder_item.dart';
import 'package:studydocs/core/widgets/feat/common/folder_list/presentation/folder_list_vertical_with_bloc.dart';
import 'package:studydocs/core/widgets/feat/document/docs_card/presentation/document_card_horizontal_carousel.dart';
import 'package:studydocs/core/widgets/feat/document/docs_card/presentation/document_card_horizontal_with_bloc.dart';
import 'package:studydocs/core/widgets/feat/document/explore/presentation/explore_header_with_bloc.dart';
import 'package:studydocs/core/widgets/feat/document/docs_card/presentation/document_card_vertical.dart';
import 'package:studydocs/core/widgets/feat/document/docs_card/presentation/document_card_square_carousel.dart';
import 'package:studydocs/core/widgets/feat/document/upload/presentation/upload_dropzone_tile.dart';
import 'package:studydocs/data/datasource/document_datasource.dart';
import 'package:studydocs/screens/test/presentation/test_screen.dart';

/// Màn hình Home — list chứa widget card đã gom Bloc (DocumentCardHorizontalWithBloc).
/// Home chỉ build list + đưa widget mới vào từng ô; Bloc tự động trong từng card, không khai báo Bloc ở Home.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final datasource = DocumentDatasource();
    final docList = datasource.getDocumentSummaryList();
    final compactList = datasource.getDocumentCompactList();
    const folderItems = [
      FolderItem(id: 'subj-1', title: 'Công nghệ phần mềm'),
      FolderItem(id: 'subj-2', title: 'Lập trình .NET'),
      FolderItem(id: 'subj-3', title: 'Lập trình Web'),
    ];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('StudyDocs'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
        itemCount: docList.length + 5,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          if (index == 0) {
            return const Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: ExploreHeaderWithBloc(
                initialSchoolName: 'Trường Đại học Nông Lâm Tp. HCM',
                initialSubjectName: 'Công nghệ phần mềm',
                initialDocumentCount: 45,
                initialUserCount: 16,
              ),
            );
          }

          if (index == 1) {
            // List ngang dạng thư mục (demo) — Home chỉ truyền data vào để hiển thị.
            return FolderListVerticalWithBloc(
              items: folderItems,
              initialSelectedId: folderItems.first.id,
            );
          }

          if (index == 2) {
            // Carousel ngang: thumbnail vuông + title (card ngang dạng compact theo design).
            return DocumentCardSquareCarousel(
              docs: compactList,
              itemSize: 100,
            );
          }

          if (index == 3) {
            // Carousel ngang cho card dọc (demo).
            return SizedBox(
              height: 190,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: compactList.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, i) {
                  return DocumentCardVertical(
                    doc: compactList[i],
                    width: 110,
                    thumbHeight: 130
                    ,
                  );
                },
              ),
            );
          }

          final cardIndex = index - 4;
          if (cardIndex < docList.length) {
            return SizedBox(
              height: 150,
              child: DocumentCardHorizontalWithBloc(
                doc: docList[cardIndex],
                repository: datasource,
              ),
            );
          }
          // Phần cuối trang: widget upload (dropzone) để test điều hướng.
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
            child: UploadDropzoneTile(
              onTap: () async {
                final result = await FilePicker.platform.pickFiles();
                final file =
                    (result != null && result.files.isNotEmpty) ? result.files.first : null;
                final path = file?.path;
                if (file == null || path == null) {
                  return;
                }
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => TestScreen(
                      fileName: file.name,
                      filePath: path,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
