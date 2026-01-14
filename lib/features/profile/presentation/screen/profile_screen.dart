import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/widgets/header.dart';
import 'package:studydocs/features/profile/domain/repository/impl/ProfileRepositoryImpl.dart';
import 'package:studydocs/data/datasource/user_datasource.dart';
import 'package:studydocs/core/network/dio_client.dart';
import 'package:studydocs/data/datasource/impl/asset_remote_datasource_impl.dart';

import 'package:studydocs/features/profile/logic/profile_bloc.dart';
import 'package:studydocs/features/profile/logic/profile_event.dart';
import 'package:studydocs/features/profile/logic/profile_state.dart';
import 'package:studydocs/features/profile/presentation/widget/BasicInfor.dart';
import 'package:studydocs/features/profile/presentation/widget/Statistical.dart';
import 'package:studydocs/features/profile/presentation/widget/StorageDocument.dart';
import 'package:studydocs/features/profile/presentation/widget/UploadDocument.dart';
import 'package:studydocs/core/widgets/upload_box.dart';
import 'package:studydocs/core/widgets/bottom_nav.dart';
import 'package:go_router/go_router.dart';
import 'package:studydocs/core/router/app_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize dependencies
    final dioClient = DioClient();
    final userDataSource = UserDataSourceImpl(
      dioClient: dioClient,
      assetRemoteDataSource: AssetRemoteDataSourceImpl(dioClient: dioClient),
    );
    final profileRepository = ProfileRepositoryImpl();
    
    return BlocProvider(create: (_) =>
    ProfileBloc(profileRepository)
      ..add(LoadProfile(0)), child: Scaffold(
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
                      BasicInfor(state: state),
                      Statistical(state: state),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: UploadBox(),
                      ),
                      UpLoadDocument(state: state),
                      StorageDocument(state: state),
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
      bottomNavigationBar: BottomNav(
        currentIndex: -1,
        onTap: (index) {
          switch (index) {
            case 0: context.go(AppRoutes.home); break;
            case 1: context.go(AppRoutes.library); break;
            case 2: context.go(AppRoutes.explore); break;
            case 3: context.go(AppRoutes.notifications); break;
          }
        },
      ),
    ),
    );
  }
}
