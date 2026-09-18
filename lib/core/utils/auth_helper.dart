import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/screens/auth/presentation/cubit/auth_cubit.dart';
import 'package:studydocs/screens/auth/presentation/cubit/auth_state.dart';
import 'package:studydocs/screens/auth/presentation/widgets/auth_dialog.dart';

class AuthHelper {
  static bool checkLogin(BuildContext context) {
    final authState = context.read<AuthCubit>().state;
    if (authState is! AuthAuthenticated) {
      showAuthDialog(context);
      return false;
    }
    return true;
  }
}
