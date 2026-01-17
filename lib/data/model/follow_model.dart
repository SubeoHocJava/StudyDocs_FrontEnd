class FollowModel {
  final String? id;
  final String? followerId;
  final String? followingId;
  final String? createdAt;

  FollowModel({
    this.id,
    this.followerId,
    this.followingId,
    this.createdAt,
  });

  factory FollowModel.fromJson(Map<String, dynamic> json) => FollowModel(
        id: json['id']?.toString(),
        followerId: json['followerId']?.toString(),
        followingId: json['followingId']?.toString(),
        createdAt: json['createdAt']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'followerId': followerId,
        'followingId': followingId,
        'createdAt': createdAt,
      };
}
