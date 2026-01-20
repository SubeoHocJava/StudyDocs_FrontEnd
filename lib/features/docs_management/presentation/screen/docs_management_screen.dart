import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/features/docs/domain/entity/document_entity.dart';
import 'package:studydocs/features/docs_management/logic/docs_management_bloc.dart';
import 'package:studydocs/features/docs_management/logic/docs_management_event.dart' as dm_event;
import 'package:studydocs/features/docs_management/logic/docs_management_state.dart';
import 'package:studydocs/features/docs_management/presentation/widgets/filter_bottom_sheet.dart';
import 'package:studydocs/features/docs_management/presentation/screen/docs_management_detail_screen.dart';
import 'package:studydocs/features/docs_management/presentation/screen/docs_edit_screen.dart';
import 'package:studydocs/features/auth/presentation/bloc/auth_status_cubit.dart';

class DocsManagementScreen extends StatefulWidget {
  final bool isAdminMode;

  const DocsManagementScreen({super.key, this.isAdminMode = false});

  @override
  State<DocsManagementScreen> createState() => _DocsManagementScreenState();
}

class _DocsManagementScreenState extends State<DocsManagementScreen> {
  bool _showOnlyMine = false;

  @override
  void initState() {
    super.initState();
    // Use auth role to decide initial load if mode not explicitly forced
    final authState = context.read<AuthStatusCubit>().state;
    final bool effectivelyAdmin = widget.isAdminMode || (authState is AuthAuthenticated && authState.isAdmin);
    
    if (effectivelyAdmin) {
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
                                      final authState = context.read<AuthStatusCubit>().state;
                                      final bool effectivelyAdmin = widget.isAdminMode || (authState is AuthAuthenticated && authState.isAdmin);

                                      if (effectivelyAdmin) {
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
                      final authState = context.read<AuthStatusCubit>().state;
                      final bool effectivelyAdmin = widget.isAdminMode || (authState is AuthAuthenticated && authState.isAdmin);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: bloc,
                            child: DocsEditScreen(isAdmin: effectivelyAdmin),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // SLIDING TOGGLE FILTER (Only in Admin Mode)
          BlocBuilder<AuthStatusCubit, AuthStatus>(
            builder: (context, authState) {
              final bool isActuallyAdmin = widget.isAdminMode || (authState is AuthAuthenticated && authState.isAdmin);
              if (isActuallyAdmin) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: _buildSlidingToggle(),
                );
              }
              return const SizedBox.shrink();
            },
          ),

          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                final bloc = context.read<DocsManagementBloc>();
                final authState = context.read<AuthStatusCubit>().state;
                final bool isActuallyAdmin = widget.isAdminMode || (authState is AuthAuthenticated && authState.isAdmin);

                if (isActuallyAdmin) {
                  if (_showOnlyMine) {
                    bloc.add(const dm_event.LoadMyDocs());
                  } else {
                    bloc.add(const dm_event.LoadAllDocs());
                  }
                } else {
                  bloc.add(const dm_event.LoadMyDocs());
                }
                // Small delay to ensure smooth feel if fast
                await Future.delayed(const Duration(milliseconds: 500));
              },
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
                      return ListView(
                        children: [
                          SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                          const Center(child: Text("Chưa có tài liệu nào")),
                        ],
                      );
                    }
              
                    final grouped = _groupDocumentsByDate(docs);
              
                    return ListView(
                      padding: const EdgeInsets.all(16),
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        if (grouped['today']!.isNotEmpty) ...[
                          _buildSectionHeader("Hôm nay"),
                          ...grouped['today']!.map((doc) => _buildDocItem(context, doc)),
                          const SizedBox(height: 16),
                        ],
                        if (grouped['yesterday']!.isNotEmpty) ...[
                          _buildSectionHeader("Hôm qua"),
                          ...grouped['yesterday']!.map((doc) => _buildDocItem(context, doc)),
                          const SizedBox(height: 16),
                        ],
                        if (grouped['earlier']!.isNotEmpty) ...[
                          _buildSectionHeader("Trước đó"),
                          ...grouped['earlier']!.map((doc) => _buildDocItem(context, doc)),
                        ],
                      ],
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  Widget _buildSlidingToggle() {
    return Container(
      height: 40,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            alignment: _showOnlyMine ? Alignment.centerRight : Alignment.centerLeft,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.45,
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (_showOnlyMine) {
                      setState(() => _showOnlyMine = false);
                      context.read<DocsManagementBloc>().add(const dm_event.LoadAllDocs());
                    }
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: Text(
                      "Tất cả",
                      style: TextStyle(
                        fontWeight: !_showOnlyMine ? FontWeight.bold : FontWeight.normal,
                        color: !_showOnlyMine ? const Color(0xFF0D0845) : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (!_showOnlyMine) {
                      setState(() => _showOnlyMine = true);
                      context.read<DocsManagementBloc>().add(const dm_event.LoadMyDocs());
                    }
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: Text(
                      "Admin tải",
                      style: TextStyle(
                        fontWeight: _showOnlyMine ? FontWeight.bold : FontWeight.normal,
                        color: _showOnlyMine ? const Color(0xFF0D0845) : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Map<String, List<DocumentEntity>> _groupDocumentsByDate(List<DocumentEntity> docs) {
    final Map<String, List<DocumentEntity>> grouped = {
      'today': [],
      'yesterday': [],
      'earlier': [],
    };

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    for (var doc in docs) {
      final date = (doc.createdAt ?? today).toLocal(); 
      final docDate = DateTime(date.year, date.month, date.day);

      if (docDate == today) {
        grouped['today']!.add(doc);
      } else if (docDate == yesterday) {
        grouped['yesterday']!.add(doc);
      } else {
        grouped['earlier']!.add(doc);
      }
    }
    return grouped;
  }

  Widget _buildDocItem(
    BuildContext context,
    DocumentEntity doc,
  ) {
    final authState = context.watch<AuthStatusCubit>().state;
    final currentUserId = authState is AuthAuthenticated ? authState.userId : null;
    final isMine = currentUserId != null && doc.uploaderId == currentUserId;

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
                      Row(
                        children: [
                          if (isMine) ...[
                            Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                    color: Colors.blue.shade100,
                                    borderRadius: BorderRadius.circular(4)),
                                child: const Text("Admin tải",
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold))),
                            const SizedBox(width: 8),
                          ] else if (!_showOnlyMine) ...[
                             _buildInfoTag(Icons.person, doc.uploader),
                             const SizedBox(width: 8),
                          ],
                          Expanded(
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 8,
                              children: [
                                _buildInfoTag(Icons.school, doc.school),
                                if (doc.course.isNotEmpty) 
                                   _buildInfoTag(Icons.book, doc.course),
                                if (doc.year.isNotEmpty)
                                  _buildInfoTag(Icons.calendar_today, doc.year),
                              ],
                            ),
                          ),
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
