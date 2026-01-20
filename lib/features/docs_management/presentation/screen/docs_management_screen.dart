import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/features/docs/domain/entity/document_entity.dart';
import 'package:studydocs/features/docs_management/logic/docs_management_bloc.dart';
import 'package:studydocs/features/docs_management/logic/docs_management_event.dart' as dm_event;
import 'package:studydocs/features/docs_management/logic/docs_management_state.dart';
import 'package:studydocs/features/docs_management/presentation/widgets/filter_bottom_sheet.dart';
import 'package:studydocs/features/docs_management/presentation/screen/docs_management_detail_screen.dart';
import 'package:studydocs/features/docs_management/presentation/screen/docs_edit_screen.dart';

class DocsManagementScreen extends StatefulWidget {
  final bool isAdminMode;

  const DocsManagementScreen({super.key, this.isAdminMode = false});

  @override
  State<DocsManagementScreen> createState() => _DocsManagementScreenState();
}

class _DocsManagementScreenState extends State<DocsManagementScreen> {
  @override
  void initState() {
    super.initState();
    // Load data initially
    if (widget.isAdminMode) {
      context.read<DocsManagementBloc>().add(const dm_event.LoadAllDocs());
    } else {
      context.read<DocsManagementBloc>().add(const dm_event.LoadMyDocs());
    }
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
                                      if (widget.isAdminMode) {
                                         context.read<DocsManagementBloc>().add(
                                          dm_event.LoadAllDocs(
                                            filterSchool: school,
                                            filterSubject: subject,
                                            filterYear: year,
                                          ),
                                        );
                                      } else {
                                        context.read<DocsManagementBloc>().add(
                                          dm_event.LoadMyDocs(
                                            filterSchool: school,
                                            filterSubject: subject,
                                            filterYear: year,
                                          ),
                                        );
                                      }
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
                      final bloc = context.read<DocsManagementBloc>();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: bloc,
                            child: DocsEditScreen(isAdmin: widget.isAdminMode),
                          ),
                        ),
                      );
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
              builder: (_) => BlocProvider.value(
                value: context.read<DocsManagementBloc>(),
                child: DocsManagementDetailScreen(
                  document: doc,
                  isAdminView: widget.isAdminMode,
                ),
              ),
            ),
          );
        },
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                 color: Colors.blue.shade50,
                 borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.description, color: Color(0xFF3F51B5), size: 28),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doc.title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center, // Aligns items vertically in the center
                    spacing: 8, // Gap between items
                    children: [
                      _buildInfoTag(Icons.school, doc.school),
                      if (doc.course.isNotEmpty) _buildInfoTag(Icons.book, doc.course),
                      if (doc.year.isNotEmpty) _buildInfoTag(Icons.calendar_today, doc.year),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.delete_outline,
                color: Colors.red,
              ),
              onPressed: () {
                // Confirm delete
                final parentContext = context; // Capture parent context which has Bloc
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
                              if (widget.isAdminMode) {
                                parentContext.read<DocsManagementBloc>().add(
                                  dm_event.DeleteAdminDocEvent(doc.id ?? ''),
                                );
                              } else {
                                parentContext.read<DocsManagementBloc>().add(
                                  dm_event.DeleteDocEvent(doc.id ?? ''),
                                );
                              }
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
  Widget _buildInfoTag(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: Colors.grey),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }
}
