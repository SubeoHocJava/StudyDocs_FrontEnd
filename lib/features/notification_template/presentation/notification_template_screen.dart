import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/features/notification_template/domain/repository/notification_template_repository.dart';
import 'package:studydocs/features/notification_template/logic/notification_template_bloc.dart';
import 'package:studydocs/features/notification_template/logic/notification_template_event.dart';
import 'package:studydocs/features/notification_template/logic/notification_template_state.dart';
import 'package:studydocs/features/notification_template/domain/usecase/create_notification_template_usecase.dart';
import 'package:studydocs/features/notification_template/domain/usecase/delete_notification_template_usecase.dart';
import 'package:studydocs/features/notification_template/domain/usecase/get_notification_template_channels_usecase.dart';
import 'package:studydocs/features/notification_template/domain/usecase/search_notification_template_keywords_usecase.dart';
import 'package:studydocs/features/notification_template/domain/usecase/get_notification_template_types_usecase.dart';
import 'package:studydocs/features/notification_template/domain/usecase/get_notification_templates_usecase.dart';
import 'package:studydocs/features/notification_template/domain/usecase/update_notification_template_usecase.dart';
import 'package:studydocs/features/notification_template/presentation/component/notification_template_item.dart';
import 'package:studydocs/features/notification_template/presentation/screen/notification_template_edit_screen.dart';
import 'package:studydocs/features/notification_template/presentation/component/notification_template_header.dart';

class NotificationTemplateScreen extends StatelessWidget {
  const NotificationTemplateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final repository = context.read<NotificationTemplateRepository>();
        return NotificationTemplateBloc(
          getTemplatesUseCase: GetNotificationTemplatesUseCase(repository),
          getTypesUseCase: GetNotificationTemplateTypesUseCase(repository),
          getChannelsUseCase: GetNotificationTemplateChannelsUseCase(repository),
          searchKeywordsUseCase: SearchNotificationTemplateKeywordsUseCase(repository),
          createTemplateUseCase: CreateNotificationTemplateUseCase(repository),
          updateTemplateUseCase: UpdateNotificationTemplateUseCase(repository),
          deleteTemplateUseCase: DeleteNotificationTemplateUseCase(repository),
        )..add(const LoadNotificationTemplatesEvent());
      },
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
                        // Hiển thị hộp thoại xác nhận trước khi xóa
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
                         // Điều hướng đến màn hình chỉnh sửa
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
    return NotificationTemplateHeader(
      searchQuery: _searchQuery,
      selectedType: _selectedType,
      selectedChannel: _selectedChannel,
      onSearchChanged: (value) {
        _searchQuery = value;
        _onFilterChanged(context);
      },
      onTypeChanged: (value) {
        setState(() => _selectedType = value);
        _onFilterChanged(context);
      },
      onChannelChanged: (value) {
        setState(() => _selectedChannel = value);
        _onFilterChanged(context);
      },
      onAddPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: context.read<NotificationTemplateBloc>(),
              child: const NotificationTemplateEditScreen(template: null),
            ),
          ),
        );
      },
    );
  }

}
