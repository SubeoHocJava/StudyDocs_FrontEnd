import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:studydocs/features/notification_template/domain/entity/category_entity.dart';
import 'package:studydocs/features/notification_template/domain/entity/channel_entity.dart';
import 'package:studydocs/features/notification_template/domain/entity/notification_template_entity.dart';
import 'package:studydocs/features/notification_template/domain/entity/notification_template_request.dart';
import 'package:studydocs/features/notification_template/logic/notification_template_bloc.dart';
import 'package:studydocs/features/notification_template/logic/notification_template_event.dart';
import 'package:studydocs/features/notification_template/logic/notification_template_state.dart';
import 'package:studydocs/features/notification_template/presentation/component/notification_metadata_modal.dart';
import 'package:studydocs/features/notification_template/presentation/component/notification_editor_components.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class NotificationTemplateEditScreen extends StatefulWidget {
  final NotificationTemplateEntity? template;

  const NotificationTemplateEditScreen({super.key, this.template});

  @override
  State<NotificationTemplateEditScreen> createState() =>
      _NotificationTemplateEditScreenState();
}

class _NotificationTemplateEditScreenState
    extends State<NotificationTemplateEditScreen> {
  late TextEditingController _nameController;
  TextEditingController? _descriptionController;
  late TextEditingController _subjectController;
  late TextEditingController _bodyController;
  
  CategoryEntity? _selectedCategory;
  ChannelEntity? _selectedChannel;

  late FocusNode _subjectFocus;
  late FocusNode _bodyFocus;
  String _activeField = 'subject';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.template?.name ?? '');
    _subjectController = TextEditingController(text: widget.template?.templateSubject ?? '');
    _bodyController = TextEditingController(text: widget.template?.templateBody ?? '');
    
    _selectedCategory = widget.template?.category;
    _selectedChannel = widget.template?.channel;
    
    
    _subjectFocus = FocusNode()..addListener(() {
      if (_subjectFocus.hasFocus) _activeField = 'subject';
    });
    
    _bodyFocus = FocusNode()..addListener(() {
      if (_bodyFocus.hasFocus) _activeField = 'body';
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController?.dispose();
    _subjectController.dispose();
    _bodyController.dispose();
    _subjectFocus.dispose();
    _bodyFocus.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_selectedCategory == null || _selectedChannel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng chọn Loại và Kênh")),
      );
      return;
    }

    if (widget.template == null) {
      // Tạo mới
      final newTemplate = NotificationTemplateRequest(
        name: _nameController.text,
        channel: _selectedChannel!,
        description: _descriptionController?.text ?? '',
        templateSubject: _subjectController.text,
        templateBody: _bodyController.text,
        category: _selectedCategory!,
      );
      context.read<NotificationTemplateBloc>().add(
            CreateNotificationTemplateEvent(newTemplate),
          );
    } else {
      // Cập nhật
      final updatedTemplate = NotificationTemplateEntity(
        id: widget.template!.id,
        name: _nameController.text,
        channel: _selectedChannel!,
        description: _descriptionController?.text ?? '',
        templateSubject: _subjectController.text,
        templateBody: _bodyController.text,
        category: _selectedCategory!,
        createdAt: widget.template!.createdAt,
        updatedAt: DateTime.now(),
      );
      context.read<NotificationTemplateBloc>().add(
            UpdateNotificationTemplateEvent(updatedTemplate),
          );
    }
    
    context.pop(); // Quay lại sau khi lưu
  }

  void _insertMetadata(String label, String key) {
    final controller = _activeField == 'subject' ? _subjectController : _bodyController;
    final textToInsert = '{$label}';
    final selection = controller.selection;
    
    if (selection.isValid && selection.start >= 0) {
      final newText = controller.text.replaceRange(
        selection.start,
        selection.end,
        textToInsert,
      );
      controller.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(
          offset: selection.start + textToInsert.length,
        ),
      );
    } else {
      // Thêm vào cuối nếu không có lựa chọn/focus
      controller.text += textToInsert;
    }
    setState(() {}); // Kích hoạt build lại để xem trước
  }
  
  void _showMetadataModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => BlocProvider.value(
        value: context.read<NotificationTemplateBloc>(),
        child: NotificationMetadataModal(onSelect: _insertMetadata),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _descriptionController ??= TextEditingController(text: widget.template?.description ?? '');

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(widget.template == null ? 'Tạo mẫu thông báo' : 'Chỉnh sửa mẫu thông báo', style: TextStyle(color: Theme.of(context).appBarTheme.foregroundColor)),
        centerTitle: false,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 1,
        leading: BackButton(
          color: Theme.of(context).appBarTheme.foregroundColor,
          onPressed: () {
             // Hộp thoại xác nhận có thể được thêm vào đây
             context.pop();
          }
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ElevatedButton(
              onPressed: _onSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Lưu'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
             // Phần thông tin
             NotificationEditorSection(
              children: [
                if (widget.template != null)
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Tên mẫu',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                ),
                const SizedBox(height: 12),
                 TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Mô tả',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                ),
                const SizedBox(height: 12),
                
                Row(
                  children: [
                    Expanded(
                      child: BlocBuilder<NotificationTemplateBloc, NotificationTemplateState>(
                        builder: (context, state) {
                          // Ensure selected category is valid if possible, or reset
                          if (_selectedCategory == null && state.categories.isNotEmpty) {
                             // _selectedCategory = state.categories.first; 
                             // Don't auto-set in build, let user select
                          }

                          return DropdownButtonFormField<CategoryEntity>(
                            initialValue: _selectedCategory, 
                            decoration: const InputDecoration(
                              labelText: 'Loại',
                              border: OutlineInputBorder(),
                               contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                            items: state.categories.map((t) => DropdownMenuItem(value: t, child: Text(t.name))).toList(),
                            onChanged: (val) => setState(() => _selectedCategory = val),
                          );
                        }
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: BlocBuilder<NotificationTemplateBloc, NotificationTemplateState>(
                        builder: (context, state) {
                           return DropdownButtonFormField<ChannelEntity>(
                            initialValue: _selectedChannel,
                            decoration: const InputDecoration(
                              labelText: 'Kênh',
                              border: OutlineInputBorder(),
                               contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                            items: state.channels.map((c) => DropdownMenuItem(value: c, child: Text(c.name))).toList(),
                            onChanged: (val) => setState(() => _selectedChannel = val),
                          );
                        }
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Trình chỉnh sửa Tiêu đề
            NotificationEditorSection(
              children: [
                NotificationEditorHeader(
                    label: 'Tiêu đề thông báo', 
                    onInsert: () {
                        _activeField = 'subject';
                        _showMetadataModal();
                    }
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _subjectController,
                  focusNode: _subjectFocus,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    hintText: 'Nhập tiêu đề thông báo...',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(12),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sử dụng dấu ngoặc nhọn để chèn từ khóa động, ví dụ: {Tên người nhận}',
                  style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Trình chỉnh sửa Nội dung
            NotificationEditorSection(
              children: [
                NotificationEditorHeader(
                    label: 'Nội dung thông báo', 
                    onInsert: () {
                        _activeField = 'body';
                        _showMetadataModal();
                    }
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _bodyController,
                  focusNode: _bodyFocus,
                  maxLines: 5,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    hintText: 'Nhập nội dung thông báo...',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(12),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Nội dung hỗ trợ nhiều dòng. Từ khóa sẽ được thay thế tự động khi gửi thông báo.',
                  style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Xem trước
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
                border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                    'Xem trước',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _subjectController.text,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                          const SizedBox(height: 8),
                          HtmlWidget(
                             _bodyController.text,
                             textStyle: TextStyle(
                               fontSize: 14,
                               color: Theme.of(context).textTheme.bodyMedium?.color,
                               height: 1.5,
                             ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}

