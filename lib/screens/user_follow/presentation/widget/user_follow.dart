import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/common/user_avatar.dart';
import '../../domain/entity/user_follow_entity.dart';

class UserFollowWidget extends StatefulWidget {
  final int initialTab;
  final List<UserFollowEntity> followers;
  final List<UserFollowEntity> following;
  final Function(String)? onUnfollow;
  final Function(String)? onRemoveFollower;
  final Function(String)? onFollow;
  final Function(String)? onUserTap;

  const UserFollowWidget({
    super.key,
    this.initialTab = 0,
    this.followers = const [],
    this.following = const [],
    this.onUnfollow,
    this.onRemoveFollower,
    this.onFollow,
    this.onUserTap,
  });

  @override
  State<UserFollowWidget> createState() => _UserFollowWidgetState();
}

class _UserFollowWidgetState extends State<UserFollowWidget>
    with SingleTickerProviderStateMixin {
  late int _activeTab;
  int? _expandedIndex;

  @override
  void initState() {
    super.initState();
    _activeTab = widget.initialTab;
  }

  @override
  Widget build(BuildContext context) {
    final List<UserFollowEntity> users = _activeTab == 0 ? widget.followers : widget.following;

    return Column(
      children: [
        const SizedBox(height: 12),
        _buildTabSelector(),
        const SizedBox(height: 14),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.only(bottom: 24),
            itemCount: users.length,
            separatorBuilder: (_, __) => const SizedBox(height: 6),
            itemBuilder: (context, index) => _buildUserItem(users[index], index),
          ),
        ),
      ],
    );
  }

  Widget _buildTabSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTab(
          label: '${widget.followers.length} Người theo dõi',
          index: 0,
          activeColor: AppColors.secondaryTeal,
        ),
        const SizedBox(width: 12),
        _buildTab(
          label: '${widget.following.length} Đang theo dõi',
          index: 1,
          activeColor: AppColors.secondaryTeal,
          activeText: AppColors.white,
        ),
      ],
    );
  }

  Widget _buildTab({
    required String label,
    required int index,
    required Color activeColor,
    Color activeText = Colors.white,
  }) {
    final bool isActive = _activeTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _activeTab = index;
          _expandedIndex = null;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? activeColor : AppColors.primaryLight,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isActive
              ? [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: const Offset(0, 2),
            )
          ]
              : [],
        ),
        child: Text(label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isActive ? activeText : AppColors.headerForeground,
            )),
      ),
    );
  }

  Widget _buildUserItem(UserFollowEntity user, int index) {
    final bool isExpanded = _expandedIndex == index;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          children: [
            InkWell(
              onTap: () => widget.onUserTap?.call(user.id),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: Row(
                  children: [
                    UserAvatar(
                      avatarUrl: user.avatarUrl,
                      radius: 24,
                      backgroundColor: AppColors.primaryLight,
                      iconColor: AppColors.headerForeground,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        user.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppColors.profileName,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_horiz, color: AppColors.headerForeground),
                      onPressed: () {
                        setState(() {
                          _expandedIndex = isExpanded ? null : index;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 240),
              curve: Curves.easeOut,
              right: isExpanded ? 0 : -140,
              top: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: () {
                  if (_activeTab == 0) {
                    widget.onRemoveFollower?.call(user.id);
                  } else {
                    widget.onUnfollow?.call(user.id);
                  }
                  setState(() => _expandedIndex = null);
                },
                child: Container(
                  width: 110,
                  color: Colors.redAccent,
                  alignment: Alignment.center,
                  child: Text(
                    _activeTab == 0 ? 'Xóa' : 'Bỏ theo dõi',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}