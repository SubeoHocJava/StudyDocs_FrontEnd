import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../logic/manage_user_bloc.dart';
import '../../logic/manage_user_event.dart';

class SearchAndAddUser extends StatelessWidget {
  const SearchAndAddUser({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ManageUserBloc>();
    return Row(
      children: [
        Expanded(
          child: TextField(
            onSubmitted: (value) {
              bloc.add(SearchUser(fromPage: 1, toPage: 3, username: value));
            },
            decoration: InputDecoration(
              hintText: 'Tìm kiếm người dùng...',
              prefixIcon: const Icon(Icons.search, color: AppColors.navy),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(
                  color: AppColors.primary, // màu border
                  width: 1.5,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(
            Icons.add_circle,
            color: AppColors.primary,
          ),
          iconSize: 35,
          onPressed: () {},
        ),
      ],
    );
  }
}
