import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// Reuse core colors
import '../../../docs/domain/entity/document_entity.dart';
import '../../logic/docs_management_bloc.dart';
import '../../logic/docs_management_event.dart';
import '../../logic/docs_management_state.dart';
import '../widgets/filter_bottom_sheet.dart';
import 'docs_management_detail_screen.dart';

class DocsManagementScreen extends StatefulWidget {
  const DocsManagementScreen({super.key});

  @override
  State<DocsManagementScreen> createState() => _DocsManagementScreenState();
}

class _DocsManagementScreenState extends State<DocsManagementScreen> {
  @override
  void initState() {
    super.initState();
    // Load data initially
    context.read<DocsManagementBloc>().add(const LoadMyDocs());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          "Quản lý tài liệu",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search & Filter Row
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.blue.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.filter_list,
                            color: Color(0xFF3F51B5),
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder:
                                  (context) => FilterBottomSheet(
                                    onApply: (school, subject, year) {
                                      context.read<DocsManagementBloc>().add(
                                        LoadMyDocs(
                                          filterSchool: school,
                                          filterSubject: subject,
                                          filterYear: year,
                                        ),
                                      );
                                    },
                                  ),
                            );
                          },
                        ),
                        const Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Tìm kiếm tài liệu, trường học",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF0D0845), // Dark Blue Button
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.add, color: Colors.white),
                    onPressed: () {
                      // Navigate to Add Document Screen (Reuse Edit Screen probably)
                    },
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: BlocBuilder<DocsManagementBloc, DocsManagementState>(
              builder: (context, state) {
                if (state is DocsManagementLoading ||
                    state is DocsManagementInitial) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is DocsManagementError) {
                  return Center(child: Text("Lỗi: ${state.message}"));
                }
                if (state is DocsManagementLoaded) {
                  final docs = state.docs;
                  if (docs.isEmpty) {
                    return const Center(child: Text("Chưa có tài liệu nào"));
                  }

                  // Mock sections "Hôm nay", "Trước đó" roughly
                  return ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          "Hôm nay",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      ...docs.map((doc) => _buildDocItem(context, doc)),
                      const SizedBox(height: 16),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          "Trước đó",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      // Just mock repeating the list for visual effect of "Earlier"
                      _buildDocItem(context, docs.first, isMockEarlier: true),
                    ],
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocItem(
    BuildContext context,
    DocumentEntity doc, {
    bool isMockEarlier = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DocsManagementDetailScreen(document: doc),
            ),
          );
        },
        child: Row(
          children: [
            const Icon(Icons.description, color: Colors.grey, size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                doc.title,
                style: const TextStyle(fontWeight: FontWeight.w500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.remove_red_eye_outlined,
                color: Colors.grey,
              ),
              onPressed: () {
                // Navigate to Detail
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => DocsManagementDetailScreen(document: doc),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () {
                // Confirm delete
                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: const Text("Xóa tài liệu?"),
                        content: Text("Bạn có chắc muốn xóa '${doc.title}'?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Hủy"),
                          ),
                          TextButton(
                            onPressed: () {
                              // Note: In real app, use Bloc event. Since we don't have ID, using title mock
                              context.read<DocsManagementBloc>().add(
                                DeleteDocEvent(doc.title),
                              );
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Xóa",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
