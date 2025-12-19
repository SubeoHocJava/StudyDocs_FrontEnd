import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/widgets/header.dart';
import 'package:studydocs/features/profile/domain/repository/impl/ProfileRepositoryImpl.dart';


import '../../../../core/widgets/bottom_nav.dart';
import '../../logic/profile_bloc.dart';
import '../../logic/profile_event.dart';
import '../../logic/profile_state.dart';
import '../widget/BasicInfor.dart';
import '../widget/Statistical.dart';
import '../widget/StorageDocument.dart';
import '../widget/UploadDocument.dart';



class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider( create: (_) => ProfileBloc(ProfileRepositoryImpl())..add(LoadProfile(0)),child: Scaffold(
      appBar: Header(),
      body:
      BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileLoaded) {
            return
              SingleChildScrollView(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BasicInfor(state:state),
                      Statistical(state:state),
                      UpLoadDocument(state:state),
                      StorageDocument(state:state),
                    ],
                  ),
                ),
              );
          }
          else if (state is ProfileError) {
            return Center(child: Text("Lỗi: ${state.message}"));
          }
          return const Center(child: Text("Chưa có dữ liệu trang profile")
          );
        },
      ),
      bottomNavigationBar: BottomNav(currentIndex: 4, onTap: (int value) {  },),
    ),);
  }
}
