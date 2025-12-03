import 'package:equatable/equatable.dart';

/// Event chung của DocsBloc
abstract class DocsEvent extends Equatable {
  const DocsEvent();

  @override
  List<Object?> get props => [];
}

/// Event load chi tiết tài liệu
class LoadDocDetails extends DocsEvent {}

/// Event đổi trạng thái save (save/un-save)
class ToggleSave extends DocsEvent {}
