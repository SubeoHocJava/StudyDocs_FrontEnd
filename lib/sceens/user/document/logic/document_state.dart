import 'package:equatable/equatable.dart';
import 'package:studydocs/sceens/user/document/domain/entity/document.dart';

abstract class DocumentState extends Equatable {
  const DocumentState();

  @override
  List<Object?> get props => [];
}

class DocumentInitial extends DocumentState {}
class DocumentLoading extends DocumentState {}

class DocumentLoaded extends DocumentState {
  final Document document;

  const DocumentLoaded({required this.document});

  @override
  List<Object?> get props => [document];
}
