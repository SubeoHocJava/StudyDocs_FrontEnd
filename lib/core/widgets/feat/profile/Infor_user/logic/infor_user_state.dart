import 'package:equatable/equatable.dart';

class InforUserState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InforUserInitial extends InforUserState {}

class InforUserLoading extends InforUserState {}

class InforUserLoaded extends InforUserState {
  final String id;
  final String fullName;
  final String? school;
  final String? avatarUrl;
  final bool isFollowing;
  final bool isOwnProfile;

  InforUserLoaded({
    required this.id,
    required this.fullName,
    required this.avatarUrl,
    required this.school,
    required this.isFollowing,
    required this.isOwnProfile,
  });

  InforUserLoaded copyWith({
    String? fullName,
    String? school,
    String? avatarUrl,
    bool? isFollowing,
    bool? isOwnProfile,
  }) {
    return InforUserLoaded(
      id: id,
      fullName: fullName ?? this.fullName,
      school: school ?? this.school,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isFollowing: isFollowing ?? this.isFollowing,
      isOwnProfile: isOwnProfile ?? this.isOwnProfile,
    );
  }

  @override
  List<Object?> get props => [
    id,
    fullName,
    school,
    avatarUrl,
    isFollowing,
    isOwnProfile,
  ];
}

class InforUserError extends InforUserState {
  final String message;

  InforUserError(this.message);

  @override
  List<Object?> get props => [message];
}

class OpenSettingDialogState extends InforUserState {
  OpenSettingDialogState();

  @override
  List<Object?> get props => [];
}
