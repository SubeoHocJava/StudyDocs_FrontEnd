import 'package:equatable/equatable.dart';

class FolderItem extends Equatable {
  final String id;
  final String title;

  const FolderItem({
    required this.id,
    required this.title,
  });

  factory FolderItem.fromJson(Map<String, dynamic> json) {
    return FolderItem(
      id: json['id'] as String,
      title: json['title'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
    };
  }

  @override
  List<Object?> get props => [id, title];
}
