import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:studydocs/features/notification_template/domain/repository/notification_template_repository.dart';
import 'package:studydocs/features/notification_template/presentation/bloc/notification_template_bloc.dart';
import 'package:studydocs/features/notification_template/presentation/bloc/notification_template_event.dart';
import 'package:studydocs/features/notification_template/presentation/bloc/notification_template_state.dart';
import 'package:studydocs/features/notification_template/presentation/component/notification_template_item.dart';
import 'package:studydocs/features/notification_template/presentation/screen/notification_template_edit_screen.dart';

class NotificationTemplateScreen extends StatelessWidget {
  const NotificationTemplateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationTemplateBloc(
        context.read<NotificationTemplateRepository>(),
      )..add(const LoadNotificationTemplatesEvent()),
      child: const _NotificationTemplateView(),
    );
  }
}

class _NotificationTemplateView extends StatefulWidget {
  const _NotificationTemplateView();

  @override
  State<_NotificationTemplateView> createState() => _NotificationTemplateViewState();
}

class _NotificationTemplateViewState extends State<_NotificationTemplateView> {
  String _searchQuery = '';
  String? _selectedType;
  String? _selectedChannel;

  
  void _onFilterChanged(BuildContext context) {
    context.read<NotificationTemplateBloc>().add(
      FilterNotificationTemplatesEvent(
        query: _searchQuery,
        type: _selectedType,
        channel: _selectedChannel,
      ),
    );
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
          "Mẫu thông báo",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: BlocBuilder<NotificationTemplateBloc, NotificationTemplateState>(
              builder: (context, state) {
                if (state.status == NotificationTemplateStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.status == NotificationTemplateStatus.failure) {
                  return Center(child: Text("Lỗi: ${state.errorMessage}"));
                }
                if (state.templates.isEmpty) {
                  return const Center(child: Text("Chưa có mẫu thông báo nào"));
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(top: 8, bottom: 20),
                  itemCount: state.templates.length,
                  itemBuilder: (context, index) {
                    final template = state.templates[index];
                    return NotificationTemplateItem(
                      template: template,
                      onDelete: () {
                        // Show confirmation dialog before delete
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text("Xác nhận xoá"),
                            content: const Text("Bạn có chắc chắn muốn xoá mẫu thông báo này không?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: const Text("Huỷ"),
                              ),
                              TextButton(
                                onPressed: () {
                                  context.read<NotificationTemplateBloc>().add(
                                    DeleteNotificationTemplateEvent(template.id),
                                  );
                                  Navigator.pop(ctx);
                                },
                                child: const Text("Xoá", style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );
                      },
                      onView: () {
                         // _showDetailModal(context, template);
                         // Navigate to Edit Screen
                         Navigator.of(context).push(
                           MaterialPageRoute(
                             builder: (_) => BlocProvider.value(
                               value: context.read<NotificationTemplateBloc>(),
                               child: NotificationTemplateEditScreen(template: template),
                             ),
                           ),
                         );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: TextField(
                    onChanged: (value) {
                      _searchQuery = value;
                      _onFilterChanged(context);
                    },
                    decoration: InputDecoration(
                      hintText: "Tìm kiếm mẫu thông báo",
                      hintStyle: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.normal),
                      prefixIcon: const Icon(Icons.search, color: Colors.blue),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(color: Colors.blue),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(color: Colors.blue),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(color: Colors.blue, width: 2),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: Colors.blue.shade900,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: context.read<NotificationTemplateBloc>(),
                          child: const NotificationTemplateEditScreen(template: null),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                 // Filter Label
                 const Text("Lọc theo: ", style: TextStyle(fontWeight: FontWeight.w500)),
                 const SizedBox(width: 8),
                  // Type Filter
                 BlocBuilder<NotificationTemplateBloc, NotificationTemplateState>(
                   buildWhen: (previous, current) => previous.types != current.types,
                   builder: (context, state) {
                     return _buildFilterChip(
                        context, 
                        label: _selectedType ?? 'Tất cả loại',
                        isSelected: _selectedType != null,
                        onTap: () {
                           _showFilterOptions(context, 'Loại', state.types, (val) {
                              setState(() => _selectedType = val);
                              _onFilterChanged(context);
                           });
                        },
                        onClear: () {
                             setState(() => _selectedType = null);
                             _onFilterChanged(context);
                        }
                     );
                   }
                 ),
                 const SizedBox(width: 8),
                 // Channel Filter
                 BlocBuilder<NotificationTemplateBloc, NotificationTemplateState>(
                   buildWhen: (previous, current) => previous.channels != current.channels,
                   builder: (context, state) {
                     return _buildFilterChip(
                        context, 
                        label: _selectedChannel ?? 'Tất cả kênh',
                        isSelected: _selectedChannel != null,
                        onTap: () {
                           _showFilterOptions(context, 'Kênh', state.channels, (val) {
                              setState(() => _selectedChannel = val);
                              _onFilterChanged(context);
                           });
                        },
                        onClear: () {
                             setState(() => _selectedChannel = null);
                             _onFilterChanged(context);
                        }
                     );
                   }
                 ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, {required String label, required bool isSelected, required VoidCallback onTap, required VoidCallback onClear}) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
           decoration: BoxDecoration(
             color: isSelected ? Colors.blue.shade100 : Colors.grey.shade100,
             borderRadius: BorderRadius.circular(20),
             border: Border.all(color: isSelected ? Colors.blue : Colors.grey.shade300),
           ),
           child: Row(
             children: [
               Text(
                 label, 
                 style: TextStyle(
                   color: isSelected ? Colors.blue.shade900 : Colors.black87,
                   fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal
                 )
               ),
               if (isSelected) ...[
                 const SizedBox(width: 4),
                 GestureDetector(
                   onTap: onClear,
                   child: Icon(Icons.close, size: 16, color: Colors.blue.shade900),
                 )
               ] else ...[
                 const SizedBox(width: 4),
                 const Icon(Icons.arrow_drop_down, size: 18, color: Colors.black54),
               ]
             ],
           ),
        ),
      );
  }

  void _showFilterOptions(BuildContext context, String title, List<String> options, Function(String?) onSelect) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Chọn $title", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ActionChip(
                    label: const Text("Tất cả"),
                    onPressed: () {
                      onSelect(null);
                      Navigator.pop(context);
                    },
                  ),
                  ...options.map((opt) => ActionChip(
                    label: Text(opt),
                    onPressed: () {
                      onSelect(opt);
                      Navigator.pop(context);
                    },
                  )).toList(),
                ],
              )
            ],
          ),
        );
      }
    );
  }

  void _showDetailModal(BuildContext context, dynamic template) {
      showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          builder: (ctx) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    template.templateSubject,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                   _detailRow("ID", template.id),
                   _detailRow("Name", template.name),
                   _detailRow("Channel", template.channel),
                   _detailRow("Type", template.type),
                   const SizedBox(height: 12),
                   const Text("Nội dung:", style: TextStyle(fontWeight: FontWeight.bold)),
                   const SizedBox(height: 4),
                   Container(
                     padding: const EdgeInsets.all(12),
                     decoration: BoxDecoration(
                       color: Colors.grey.shade100,
                       borderRadius: BorderRadius.circular(8),
                     ),
                     child: Text(template.templateBody),
                   ),
                   const SizedBox(height: 20),
                ],
              ),
            );
          },
      );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              "$label:",
              style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.grey),
            ),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.black87)),
          ),
        ],
      ),
    );
  }
}
