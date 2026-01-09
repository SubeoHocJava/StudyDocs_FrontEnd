import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:studydocs/features/notification_template/domain/entity/notification_template_entity.dart';
import 'package:studydocs/features/notification_template/logic/notification_template_bloc.dart';
import 'package:studydocs/features/notification_template/logic/notification_template_event.dart';
import 'package:studydocs/features/notification_template/logic/notification_template_state.dart';
import 'package:studydocs/features/notification_template/presentation/component/notification_metadata_modal.dart';
import 'package:studydocs/features/notification_template/presentation/component/notification_editor_components.dart';

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
  late TextEditingController _subjectController;
  late TextEditingController _bodyController;
  
  String _selectedType = 'LIKE';
  String _selectedChannel = 'EMAIL';

  // NOTE: In real app, we should check if _selectedType/Channel is in the list of available types/channels
  // If not, maybe fetch them or default to first one. Here we assume generic first values or whatever comes from template.
  
  // Nút focus để theo dõi trường văn bản nào đang hoạt động
  late FocusNode _subjectFocus;
  late FocusNode _bodyFocus;
  String _activeField = 'subject'; // 'subject' hoặc 'body'

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.template?.name ?? '');
    _subjectController = TextEditingController(text: widget.template?.templateSubject ?? '');
    _bodyController = TextEditingController(text: widget.template?.templateBody ?? '');
    
    _selectedType = widget.template?.type ?? 'LIKE';
    _selectedChannel = widget.template?.channel ?? 'EMAIL';
    
    
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
    _subjectController.dispose();
    _bodyController.dispose();
    _subjectFocus.dispose();
    _bodyFocus.dispose();
    super.dispose();
  }

  void _onSave() {
    if (widget.template == null) {
      // Tạo mới
      final newTemplate = NotificationTemplateEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(), // ID giả lập
        name: _nameController.text,
        channel: _selectedChannel,
        description: "Tạo từ ứng dụng",
        templateSubject: _subjectController.text,
        templateBody: _bodyController.text,
        type: _selectedType,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      context.read<NotificationTemplateBloc>().add(
            CreateNotificationTemplateEvent(newTemplate),
          );
    } else {
      // Cập nhật
      final updatedTemplate = NotificationTemplateEntity(
        id: widget.template!.id,
        name: _nameController.text,
        channel: _selectedChannel,
        description: widget.template!.description,
        templateSubject: _subjectController.text,
        templateBody: _bodyController.text,
        type: _selectedType,
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
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(widget.template == null ? 'Tạo mẫu thông báo' : 'Chỉnh sửa mẫu thông báo', style: const TextStyle(color: Colors.black)),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 1,
        leading: BackButton(
          color: Colors.black,
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
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
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
                   NotificationInfoRow(label: 'ID', value: widget.template!.id),
                
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
                
                Row(
                  children: [
                    Expanded(
                      child: BlocBuilder<NotificationTemplateBloc, NotificationTemplateState>(
                        builder: (context, state) {
                          // Đảm bảo loại đã chọn có trong danh sách, hoặc mặc định
                          final types = state.types.isNotEmpty ? state.types : ['LIKE', 'COMMENT', 'CUSTOM']; 
                          
                          return DropdownButtonFormField<String>(
                            value: _selectedType, // Should verify this value exists in items or is handled
                            decoration: const InputDecoration(
                              labelText: 'Loại',
                              border: OutlineInputBorder(),
                               contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                            items: types.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                            onChanged: (val) => setState(() => _selectedType = val!),
                          );
                        }
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: BlocBuilder<NotificationTemplateBloc, NotificationTemplateState>(
                        builder: (context, state) {
                           final channels = state.channels.isNotEmpty ? state.channels : ['EMAIL', 'PUSH', 'SMS'];

                          return DropdownButtonFormField<String>(
                            value: _selectedChannel,
                            decoration: const InputDecoration(
                              labelText: 'Kênh',
                              border: OutlineInputBorder(),
                               contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                            items: channels.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                            onChanged: (val) => setState(() => _selectedChannel = val!),
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
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
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
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Xem trước
            Container(
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                border: Border.all(color: Colors.blue.shade100),
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
                      color: Colors.blue.shade700,
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
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                         Text(
                          _bodyController.text,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
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

