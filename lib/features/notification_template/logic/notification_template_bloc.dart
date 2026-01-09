import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/features/notification_template/domain/entity/notification_metadata_entity.dart';
import 'package:studydocs/features/notification_template/domain/entity/notification_template_entity.dart';
import 'package:studydocs/features/notification_template/domain/usecase/create_notification_template_usecase.dart';
import 'package:studydocs/features/notification_template/domain/usecase/delete_notification_template_usecase.dart';
import 'package:studydocs/features/notification_template/domain/usecase/get_notification_template_channels_usecase.dart';
import 'package:studydocs/features/notification_template/domain/usecase/search_notification_template_keywords_usecase.dart';
import 'package:studydocs/features/notification_template/domain/usecase/get_notification_template_types_usecase.dart';
import 'package:studydocs/features/notification_template/domain/usecase/get_notification_templates_usecase.dart';
import 'package:studydocs/features/notification_template/domain/usecase/update_notification_template_usecase.dart';

import 'notification_template_event.dart';
import 'notification_template_state.dart';

class NotificationTemplateBloc extends Bloc<NotificationTemplateEvent, NotificationTemplateState> {
  final GetNotificationTemplatesUseCase getTemplatesUseCase;
  final GetNotificationTemplateTypesUseCase getTypesUseCase;
  final GetNotificationTemplateChannelsUseCase getChannelsUseCase;
  final SearchNotificationTemplateKeywordsUseCase searchKeywordsUseCase;
  final CreateNotificationTemplateUseCase createTemplateUseCase;
  final UpdateNotificationTemplateUseCase updateTemplateUseCase;
  final DeleteNotificationTemplateUseCase deleteTemplateUseCase;

  NotificationTemplateBloc({
    required this.getTemplatesUseCase,
    required this.getTypesUseCase,
    required this.getChannelsUseCase,
    required this.searchKeywordsUseCase,
    required this.createTemplateUseCase,
    required this.updateTemplateUseCase,
    required this.deleteTemplateUseCase,
  }) : super(const NotificationTemplateState()) {
    on<LoadNotificationTemplatesEvent>(_onLoadTemplates);
    on<FilterNotificationTemplatesEvent>(_onFilterTemplates);
    on<DeleteNotificationTemplateEvent>(_onDeleteTemplate);
    on<UpdateNotificationTemplateEvent>(_onUpdateTemplate);
    on<CreateNotificationTemplateEvent>(_onCreateTemplate);
  }

  Future<void> _onLoadTemplates(
    LoadNotificationTemplatesEvent event,
    Emitter<NotificationTemplateState> emit,
  ) async {
    emit(state.copyWith(status: NotificationTemplateStatus.loading));
    try {
      final results = await Future.wait([
         getTemplatesUseCase(),
         getTypesUseCase(),
         getChannelsUseCase(),
         searchKeywordsUseCase(''),
      ]);

      final templates = results[0] as List<NotificationTemplateEntity>;
      final types = results[1] as List<String>;
      final channels = results[2] as List<String>;
      final keywords = results[3] as List<NotificationKeywordGroup>;

      emit(state.copyWith(
        status: NotificationTemplateStatus.success,
        templates: templates,
        allTemplates: templates,
        types: types,
        channels: channels,
        keywords: keywords,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: NotificationTemplateStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onFilterTemplates(
    FilterNotificationTemplatesEvent event,
    Emitter<NotificationTemplateState> emit,
  ) async {
    emit(state.copyWith(status: NotificationTemplateStatus.loading)); // Hiển thị loading trong khi "tìm kiếm"
    try {
      final filtered = await getTemplatesUseCase(
        GetNotificationTemplatesParams(
          query: event.query,
          type: event.type,
          channel: event.channel,
        ),
      );
      emit(state.copyWith(
        status: NotificationTemplateStatus.success,
        templates: filtered,
      ));
    } catch (e) {
      emit(state.copyWith(
         status: NotificationTemplateStatus.failure,
         errorMessage: e.toString()
      ));
    }
  }

  Future<void> _onDeleteTemplate(
    DeleteNotificationTemplateEvent event,
    Emitter<NotificationTemplateState> emit,
  ) async {
    // Cập nhật lạc quan (Optimistic Update)
    final currentTemplates = List<NotificationTemplateEntity>.from(state.templates);
    currentTemplates.removeWhere((t) => t.id == event.id);
    
    final currentAllTemplates = List<NotificationTemplateEntity>.from(state.allTemplates);
    currentAllTemplates.removeWhere((t) => t.id == event.id);

    emit(state.copyWith(
      templates: currentTemplates,
      allTemplates: currentAllTemplates,
    ));

    try {
      await deleteTemplateUseCase(event.id);
    } catch (e) {
      // Khôi phục nếu thất bại (Tải lại)
      add(const LoadNotificationTemplatesEvent());
    }
  }

  Future<void> _onUpdateTemplate(
    UpdateNotificationTemplateEvent event,
    Emitter<NotificationTemplateState> emit,
  ) async {
    emit(state.copyWith(status: NotificationTemplateStatus.loading));
    try {
      await updateTemplateUseCase(event.template);
      // Tải lại danh sách để lấy dữ liệu mới
      add(const LoadNotificationTemplatesEvent());
    } catch (e) {
      emit(state.copyWith(
        status: NotificationTemplateStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onCreateTemplate(
    CreateNotificationTemplateEvent event,
    Emitter<NotificationTemplateState> emit,
  ) async {
    emit(state.copyWith(status: NotificationTemplateStatus.loading));
    try {
      await createTemplateUseCase(event.template);
      // Tải lại danh sách để lấy dữ liệu mới
      add(const LoadNotificationTemplatesEvent());
    } catch (e) {
      emit(state.copyWith(
        status: NotificationTemplateStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
