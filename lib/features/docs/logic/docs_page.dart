import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/docs_repository.dart';
import 'docs_bloc.dart';
import 'docs_event.dart';
import '../presentation/screen/docs_screen.dart';

class DocsPage extends StatelessWidget {
  const DocsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DocsBloc(DocsRepository())..add(LoadDocDetails()),
      child: const DocsScreen(),
    );
  }
}
