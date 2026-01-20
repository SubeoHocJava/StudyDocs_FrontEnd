import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/utils/responsive_helper.dart';
import 'package:studydocs/features/manage_user/logic/manage_user_bloc.dart';
import 'package:studydocs/features/manage_user/logic/manage_user_event.dart';

import '../../../../data/model/user.dart';
import 'detail_user_dialog.dart';

class ListUser extends StatelessWidget {
  final List<UserModel> listUser;

  const ListUser({super.key, required this.listUser});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    print('UI users length = ${listUser.length}');
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: listUser.length,
      itemBuilder: (context, index) {
        final user = listUser[index];
        return Padding(
          padding: EdgeInsets.symmetric(
            vertical: responsive.heightPercent(0.5),
          ),
          child: MonoUser(user: user, index: index),
        );
      },
    );
  }
}

class MonoUser extends StatelessWidget {
  final UserModel user;
  final int index;

  const MonoUser({super.key, required this.user, required this.index});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ManageUserBloc>();
    return InkWell(
      onTap: () => _showUserDetailDialog(context, user),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            ClipOval(
              child: SizedBox(
                width: 48,
                height: 48,
                child: Image.asset(
                  "assets/icons/Test_AVT_user.jpg",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // 📄 Name + username
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.fullName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.username,
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.delete_outline_sharp, color: Colors.red),
              onSelected: (value) {
                if (value == 'delete') {
                  bloc.add(DeleteUser(user.id));
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Xác nhận xóa?',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void _showUserDetailDialog(BuildContext context, UserModel user) {
  final bloc = context.read<ManageUserBloc>();
  showDialog(
    context: context,
    builder: (context) => DetailUserDialog(bloc: bloc, user: user),
  );
}
