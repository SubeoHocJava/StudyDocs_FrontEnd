import 'package:flutter/material.dart';
import 'package:studydocs/core/widgets/feat/document/explore/presentation/explore_header_with_bloc.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('StudyDocs'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body:  const Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: ExploreHeaderWithBloc(
                initialSchoolName: 'Trường Đại học Nông Lâm Tp. HCM',
                initialSubjectName: 'Công nghệ phần mềm',
                initialDocumentCount: 45,
                initialUserCount: 16,
              ),
            ),
      );
  }
}
