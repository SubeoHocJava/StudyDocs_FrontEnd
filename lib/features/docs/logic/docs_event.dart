import 'package:equatable/equatable.dart';

abstract class DocsEvent extends Equatable {
  const DocsEvent();
  @override
  List<Object?> get props => [];
}

class LoadDocDetails extends DocsEvent {}

class ToggleSave extends DocsEvent {}
