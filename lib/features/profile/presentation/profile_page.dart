import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../screens/profile_screen.dart';
import '../logic/profile_bloc.dart';
import '../data/profile_repository.dart';
import '../logic/profile_event.dart';

class ProfilePage extends StatelessWidget {
  final int userId;

  const ProfilePage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileBloc(ProfileRepository())..add(LoadProfile(userId)),
      child: const ProfileScreen(),
    );
  }
}
