import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/widgets/feat/update_infor_form/logic/update_infor_bloc.dart';
import 'core/widgets/feat/update_infor_form/presentation/UpdateInforDialog.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UpdateInforBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const TestScreen(),
      ),
    );
  }
}

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Test giao diện")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (_) {
                return BlocProvider.value(
                  value: context.read<UpdateInforBloc>(),
                  child: const Dialog(
                    backgroundColor: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: UpdateInforDialog(),
                    ),
                  ),
                );
              },
            );
          },
          child: const Text("Mở form cập nhật"),
        ),
      ),
    );
  }
}
