import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'error_notification_widget.dart';

void showErrorSnackBar(BuildContext context, String message, {String title = 'Lỗi'}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        padding: EdgeInsets.zero,
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height - 150),
        content: ErrorNotificationWidget(
          errorCode: title,
          errorDescription: message,
          onDismissed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
        ),
        duration: const Duration(seconds: 4),
      ),
    );
}

class GlobalErrorListener<B extends StateStreamable<S>, S> extends StatelessWidget {
  final Widget child;
  final String? Function(S state) errorExtractor;

  const GlobalErrorListener({
    super.key,
    required this.child,
    required this.errorExtractor,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<B, S>(
      listener: (context, state) {
        final errorMessage = errorExtractor(state);
        if (errorMessage != null && errorMessage.isNotEmpty) {
          showErrorSnackBar(context, errorMessage);
        }
      },
      child: child,
    );
  }
}
