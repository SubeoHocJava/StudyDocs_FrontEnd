import 'package:flutter/material.dart';
import 'package:studydocs/services/token_storage_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/widgets/header.dart';
import 'package:studydocs/features/profile/domain/repository/impl/ProfileRepositoryImpl.dart';

import 'package:studydocs/features/profile/logic/profile_bloc.dart';
import 'package:studydocs/features/profile/logic/profile_event.dart';
import 'package:studydocs/features/profile/logic/profile_state.dart';
import 'package:studydocs/features/profile/presentation/widget/BasicInfor.dart';
import 'package:studydocs/features/profile/presentation/widget/Statistical.dart';
import 'package:studydocs/features/profile/presentation/widget/StorageDocument.dart';
import 'package:studydocs/core/router/app_router.dart';
import 'package:studydocs/features/library/presentation/widget/library_widgets.dart';
import 'package:studydocs/features/upload_file/domain/data/impl/upload_file_repository_implement.dart';
import 'package:studydocs/features/upload_file/domain/usecase/upload_file_usecase.dart';
import 'package:studydocs/features/upload_file/logic/upload_file_bloc.dart';
import 'package:studydocs/features/upload_file/logic/upload_file_event.dart';
import 'package:studydocs/features/upload_file/presentation/screen/upload_file_screen.dart';
import 'package:studydocs/core/widgets/bottom_nav.dart';
import 'package:go_router/go_router.dart';
import 'package:studydocs/features/profile/presentation/widget/UploadDocument.dart';
class ProfileScreen extends StatefulWidget {
  final String? userId;

  const ProfileScreen({
    super.key,
    this.userId,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<String?> _userIdFuture;

  @override
  void initState() {
    super.initState();
    _userIdFuture = _resolveUserId();
  }

  Future<String?> _resolveUserId() async {
    if (widget.userId != null && widget.userId!.isNotEmpty) {
      return widget.userId;
    }
    // Lấy userId từ token nếu không truyền vào
    return await TokenStorageService().getUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(),
      body: FutureBuilder<String?>(
        future: _userIdFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Text("Không tìm thấy thông tin người dùng: ${snapshot.error ?? 'Unknown error'}"),
            );
          }

          final userId = snapshot.data!;
          final profileRepository = ProfileRepositoryImpl();

          return BlocProvider(
            create: (_) => ProfileBloc(profileRepository)
              ..add(LoadProfile(userId)),
            child: BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                if (state is ProfileLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ProfileLoaded) {
                  return SingleChildScrollView(
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BasicInfor(state: state),
                          Statistical(state: state),
                          UploadFileButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                    create: (context) => UploadFileBloc(
                                      uploadFileUseCase: UploadFileUseCase(
                                        repository: UpLoadFileRepositoryImpl(),
                                      ),
                                    )..add(const UploadFileLoadDocumentByKeyWord("keyword")),
                                    child: const UploadFileScreen(),
                                  ),
                                ),
                              );
                            },
                          ),
                          UpLoadDocument(state: state),
                          StorageDocument(state: state),
                        ],
                      ),
                    ),
                  );
                } else if (state is ProfileError) {
                  return Center(child: Text("Lỗi: ${state.message}"));
                }
                return const Center(child: Text("Chưa có dữ liệu trang profile"));
              },
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: -1,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go(AppRoutes.home);
              break;
            case 1:
              context.go(AppRoutes.library);
              break;
            case 2:
              context.go(AppRoutes.explore);
              break;
            case 3:
              context.go(AppRoutes.notifications);
              break;
          }
        },
      ),
    );
  }
}
