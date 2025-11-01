import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../logic/docs_bloc.dart';
import '../logic/docs_state.dart';
import '../logic/docs_event.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_colors.dart';

class DocsDetailScreen extends StatefulWidget {
  const DocsDetailScreen({super.key});

  @override
  _DocsDetailScreenState createState() => _DocsDetailScreenState();
}

class _DocsDetailScreenState extends State<DocsDetailScreen> {
  int _currentPage = 0;
  final int _commentsPerPage = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<DocsBloc, DocsState>(
          builder: (context, state) {
            if (state is DocsLoading || state is DocsInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is DocsLoaded) {
              final doc = state.docDetails;
              final comments = doc["comments"] as List<dynamic>;
              final totalPages = (comments.length / _commentsPerPage).ceil();
              final startIndex = _currentPage * _commentsPerPage;
              final endIndex = (startIndex + _commentsPerPage) > comments.length
                  ? comments.length
                  : startIndex + _commentsPerPage;
              final paginatedComments = comments.sublist(startIndex, endIndex);

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title + mũi tên ngược lên
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            doc["title"],
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton(
                          tooltip: 'Thu gọn về tài liệu sơ bộ',
                          icon: const Icon(Icons.arrow_drop_up),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // course
                    Row(
                      children: [
                        Image.asset(AppAssets.folder, width: 20, height: 20),
                        const SizedBox(width: 6),
                        Expanded(child: Text(doc["course"])),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // school
                    Row(
                      children: [
                        Image.asset(AppAssets.school, width: 20, height: 20),
                        const SizedBox(width: 6),
                        Expanded(child: Text(doc["school"])),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Download + Save
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: Image.asset(AppAssets.download, width: 20, height: 20),
                          label: const Text("Tải về"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.followerBg,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () =>
                              context.read<DocsBloc>().add(ToggleSave()),
                          icon: Image.asset(
                            state.isSaved ? AppAssets.saved : AppAssets.unsaved,
                            width: 20,
                            height: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Năm học
                    Text("Năm học: ${doc["year"]}"),
                    //const SizedBox(height: 12),

                    Text("Đăng tải bởi:"),
                    // Đăng tải bởi (avatar + tên + school bên dưới)
                    ListTile(
                      leading: CircleAvatar(
                        radius: 22,
                        backgroundImage: AssetImage(AppAssets.avt),
                      ),
                      title: Text(
                        doc["uploader"],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Row(
                        children: [
                          Image.asset(AppAssets.school, width: 16, height: 16),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              doc["school"],
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                      contentPadding: EdgeInsets.zero,
                    ),
                    const SizedBox(height: 12),

                    // Like / Unlike: 2 nút bo góc
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 42, vertical: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(AppAssets.like, width: 18, height: 18),
                              const SizedBox(width: 6),
                              Text("${doc["likes"]}"),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 42, vertical: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Transform.scale(
                                scaleY: -1,
                                child: Image.asset(AppAssets.like, width: 18, height: 18),
                              ),
                              const SizedBox(width: 6),
                              Text("${doc["dislikes"]}"),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // PDF
                    Container(
                      height: 420,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: const Center(child: Text("PDF full ở đây")),
                    ),
                    const SizedBox(height: 20),

                    const Divider(),
                    const Text(
                      "Bình luận",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 12),

                    // Comment list với phân trang
                    ...List.generate(paginatedComments.length, (i) {
                      final c = paginatedComments[i];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundImage: AssetImage(AppAssets.avt),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    c["author"],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(c["text"]),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),

                    // Điều hướng phân trang
                    if (comments.length > _commentsPerPage)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: _currentPage > 0
                                ? () {
                              setState(() {
                                _currentPage--;
                              });
                            }
                                : null,
                            child: const Text("Trước"),
                          ),
                          Text("Trang ${_currentPage + 1}/$totalPages"),
                          ElevatedButton(
                            onPressed: _currentPage < totalPages - 1
                                ? () {
                              setState(() {
                                _currentPage++;
                              });
                            }
                                : null,
                            child: const Text("Sau"),
                          ),
                        ],
                      ),
                    const SizedBox(height: 20),

                    // Khung nhập bình luận + nút gửi tách rời
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Bạn nghĩ gì về tài liệu này...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {},
                          child: const Text("Gửi"),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }

            return const Center(child: Text("Đã có lỗi xảy ra"));
          },
        ),
      ),
    );
  }
}