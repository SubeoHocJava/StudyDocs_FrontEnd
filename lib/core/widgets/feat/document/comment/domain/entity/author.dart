import 'package:equatable/equatable.dart';

class Author extends Equatable {
  final String id;
  final String avatarUrl;
  final String fullName;

  const Author({required this.id, required this.avatarUrl, required this.fullName});

  @override
  List<Object?> get props => [id, avatarUrl, fullName];
}
