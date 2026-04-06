import 'package:equatable/equatable.dart';

class UserFollowEntity extends Equatable {
  final String id;
  final String name;
  final String? avatarUrl;
  final bool isFollowing;

  const UserFollowEntity({
    required this.id,
    required this.name,
    this.avatarUrl,
    this.isFollowing = false,
  });

  @override
  List<Object?> get props => [id, name, avatarUrl, isFollowing];
}
