import 'package:flutter/material.dart';

import '../../../library/logic/LibraryEvent.dart';
import '../widget/BasicInfor.dart';
import '../widget/Statistical.dart';
import '../widget/StoreageDocument.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text("Thông tin cá nhân")),
      body:
      // BlocBuilder<ProfileBloc, ProfileState>(
      //   builder: (context, state) {
      //     if (state is ProfileLoading) {
      //       return const Center(child: CircularProgressIndicator());
      //     } else if (state is ProfileLoaded) {
      //       final profile = state.profile;
      //       return
      SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BasicInfor(),
              Statistical(),

              StorageDocument(),
            ],
          ),
        ),
      ),
      // }
      //     else if (state is ProfileError) {
      //       return Center(child: Text("Lỗi: ${state.message}"));
      //     }
      //     return const Center(child: Text("Chưa có dữ liệu"));
      //   },
      // ),
    );
  }
}
