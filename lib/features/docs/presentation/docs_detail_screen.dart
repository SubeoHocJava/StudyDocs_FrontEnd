import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../logic/docs_bloc.dart';
import '../logic/docs_state.dart';
import '../logic/docs_event.dart';

class DocsDetailScreen extends StatelessWidget {
  const DocsDetailScreen({super.key});

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
                        const Icon(Icons.folder, size: 20),
                        const SizedBox(width: 6),
                        Text(doc["course"]),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // school
                    Row(
                      children: [
                        const Icon(Icons.school, size: 20),
                        const SizedBox(width: 6),
                        Text(doc["school"]),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Download + Save
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.download),
                          label: const Text("Tải về"),
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: state.isSaved
                                ? const Color(0xFFFFD700)
                                : Colors.grey,
                            foregroundColor:
                            state.isSaved ? Colors.black : Colors.white,
                          ),
                          onPressed: () =>
                              context.read<DocsBloc>().add(ToggleSave()),
                          icon: const Icon(Icons.bookmark),
                          label: Text(state.isSaved ? "Đã lưu" : "Lưu"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Năm học
                    Text("Năm học: ${doc["year"]}"),
                    const SizedBox(height: 12),

                    // Đăng tải bởi (avatar + tên + school)
                    ListTile(
                      leading: const CircleAvatar(
                        radius: 22,
                        child: Icon(Icons.person),
                      ),
                      title: Text(
                        doc["uploader"],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(doc["school"]),
                      contentPadding: EdgeInsets.zero,
                    ),
                    const SizedBox(height: 12),

                    // Like / Unlike: 2 nút bo góc
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.thumb_up_alt_outlined, size: 18),
                              const SizedBox(width: 6),
                              Text("${doc["likes"]}"),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.thumb_down_alt_outlined, size: 18),
                              const SizedBox(width: 6),
                              Text("${doc["dislikes"]}"),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    const Divider(),
                    const Text(
                      "Bình luận",
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 12),

                    // Comment list với bo góc
                    ...List.generate(doc["comments"].length, (i) {
                      final c = doc["comments"][i];
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
                            const CircleAvatar(
                              radius: 18,
                              child: Icon(Icons.person, size: 20),
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
