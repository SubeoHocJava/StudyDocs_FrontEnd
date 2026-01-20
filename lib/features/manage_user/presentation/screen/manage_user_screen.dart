import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/features/manage_user/domain/repository/impl/ManageUserRepositoryImpl.dart';
import 'package:studydocs/features/manage_user/domain/repository/manage_user_repository.dart';
import 'package:studydocs/features/manage_user/logic/manage_user_bloc.dart';
import 'package:studydocs/features/manage_user/logic/manage_user_event.dart';
import 'package:studydocs/features/manage_user/logic/manage_user_state.dart';

import '../widget/list_user.dart';
import '../widget/search_add_btn.dart';

class ManageUserScreen extends StatelessWidget {
  const ManageUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<ManageUserRepository>(
      create: (_) => ManageUserRepositoryImpl(),
      child: BlocProvider(
        create:
            (context) =>
                createManageUserBloc(context.read<ManageUserRepository>())
                  ..add(LoadListUser(fromPage: 1, toPage: 3, numUser: 10)),
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            elevation: 0,
            leading: BackButton(color: Theme.of(context).appBarTheme.foregroundColor),
            title: Text(
              "Quản lý người dùng",
              style: TextStyle(
                color: Theme.of(context).appBarTheme.foregroundColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          body: BlocListener<ManageUserBloc, ManageUserState>(
            listener: (context, state) {
              if (state is ManageUserLoaded && state.successMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.successMessage!),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              } else if (state is ManageUserError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: BlocBuilder<ManageUserBloc, ManageUserState>(
              builder: (context, state) {
                if (state is ManageUserLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is ManageUserLoaded) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<ManageUserBloc>().add(
                        const LoadListUser(fromPage: 1, toPage: 3, numUser: 10),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          SearchAndAddUser(),
                          const SizedBox(height: 12),
                          Expanded(child: ListUser(listUser: state.listUser)),
                        ],
                      ),
                    ),
                  );
                }

                if (state is ManageUserError) {
                  return Center(child: Text('Lỗi: ${state.message}'));
                }

                return const Center(child: Text('Chưa có dữ liệu người dùng'));
              },
            ),
          ),
        ),
      ),
    );
  }
}
