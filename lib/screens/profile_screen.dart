import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/profile/logic/profile_bloc.dart';
import '../features/profile/logic/profile_event.dart';
import '../features/profile/logic/profile_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Thông tin cá nhân")),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileLoaded) {
            final profile = state.profile;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("ID: ${profile['id']}", style: const TextStyle(fontSize: 18)),
                  Text("Tên: ${profile['name']}", style: const TextStyle(fontSize: 18)),
                  Text("Email: ${profile['email']}", style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Giả sử update tên
                      context.read<ProfileBloc>().add(
                        UpdateProfile({
                          "id": profile['id'],
                          "name": "Tên mới",
                          "email": profile['email'],
                        }),
                      );
                    },
                    child: const Text("Cập nhật Profile"),
                  ),
                ],
              ),
            );
          } else if (state is ProfileError) {
            return Center(child: Text("Lỗi: ${state.message}"));
          }
          return const Center(child: Text("Chưa có dữ liệu"));
        },
      ),
    );
  }
}
