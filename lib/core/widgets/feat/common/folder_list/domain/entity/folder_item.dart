import 'package:equatable/equatable.dart';

class FolderItem extends Equatable {
  final String id;
  final String title;

  const FolderItem({
    required this.id,
    required this.title,
  });

  @override
  List<Object?> get props => [id, title];
}

