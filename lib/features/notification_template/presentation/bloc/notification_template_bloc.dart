import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/features/notification_template/domain/entity/notification_metadata_entity.dart';
import 'package:studydocs/features/notification_template/domain/entity/notification_template_entity.dart';
import 'package:studydocs/features/notification_template/domain/repository/notification_template_repository.dart';
import 'package:studydocs/features/notification_template/presentation/bloc/notification_template_event.dart';
import 'package:studydocs/features/notification_template/presentation/bloc/notification_template_state.dart';

class NotificationTemplateBloc extends Bloc<NotificationTemplateEvent, NotificationTemplateState> {
  final NotificationTemplateRepository repository;

  NotificationTemplateBloc(this.repository) : super(const NotificationTemplateState()) {
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
         repository.getTemplates(),
         repository.getTypes(),
         repository.getChannels(),
         repository.getKeywords(),
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
    emit(state.copyWith(status: NotificationTemplateStatus.loading)); // Show loading while "searching"
    try {
      final filtered = await repository.getTemplates(
        query: event.query,
        type: event.type,
        channel: event.channel,
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
    // Optimistic Update
    final currentTemplates = List<NotificationTemplateEntity>.from(state.templates);
    currentTemplates.removeWhere((t) => t.id == event.id);
    
    final currentAllTemplates = List<NotificationTemplateEntity>.from(state.allTemplates);
    currentAllTemplates.removeWhere((t) => t.id == event.id);

    emit(state.copyWith(
      templates: currentTemplates,
      allTemplates: currentAllTemplates,
    ));

    try {
      await repository.deleteTemplate(event.id);
    } catch (e) {
      // Revert if failed (Reload)
      add(const LoadNotificationTemplatesEvent());
    }
  }

  Future<void> _onUpdateTemplate(
    UpdateNotificationTemplateEvent event,
    Emitter<NotificationTemplateState> emit,
  ) async {
    emit(state.copyWith(status: NotificationTemplateStatus.loading));
    try {
      await repository.updateTemplate(event.template);
      // Reload the list to get fresh data
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
      await repository.createTemplate(event.template);
      // Reload the list to get fresh data
      add(const LoadNotificationTemplatesEvent());
    } catch (e) {
      emit(state.copyWith(
        status: NotificationTemplateStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
