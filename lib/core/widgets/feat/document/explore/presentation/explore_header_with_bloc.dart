import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/widgets/feat/document/explore/logic/explore_header_bloc.dart';
import 'package:studydocs/core/widgets/feat/document/explore/logic/explore_header_event.dart';
import 'package:studydocs/core/widgets/feat/document/explore/logic/explore_header_state.dart';
import 'package:studydocs/core/widgets/feat/document/explore/presentation/explore_header.dart';

/// Widget gom Bloc cho ExploreHeader.
/// Page chỉ cần dùng widget này, sau đó bắt `onSearchChanged` để filter danh sách tài liệu.
class ExploreHeaderWithBloc extends StatelessWidget {
  final String initialSchoolName;
  final String initialSubjectName;
  final int initialDocumentCount;
  final int initialUserCount;
  final String initialSearchText;
  final VoidCallback? onSchoolEdit;
  final VoidCallback? onSubjectEdit;
  final ValueChanged<String>? onSearchChanged;

  const ExploreHeaderWithBloc({
    super.key,
    required this.initialSchoolName,
    required this.initialSubjectName,
    required this.initialDocumentCount,
    required this.initialUserCount,
    this.initialSearchText = '',
    this.onSchoolEdit,
    this.onSubjectEdit,
    this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ExploreHeaderBloc(
        initialSchoolName: initialSchoolName,
        initialSubjectName: initialSubjectName,
        initialDocumentCount: initialDocumentCount,
        initialUserCount: initialUserCount,
        initialSearchText: initialSearchText,
      )..add(
          ExploreHeaderInitialized(
            schoolName: initialSchoolName,
            subjectName: initialSubjectName,
            documentCount: initialDocumentCount,
            userCount: initialUserCount,
            searchText: initialSearchText,
          ),
        ),
      child: _ExploreHeaderWithBlocBody(
        onSchoolEdit: onSchoolEdit,
        onSubjectEdit: onSubjectEdit,
        onSearchChanged: onSearchChanged,
      ),
    );
  }
}

class _ExploreHeaderWithBlocBody extends StatelessWidget {
  final VoidCallback? onSchoolEdit;
  final VoidCallback? onSubjectEdit;
  final ValueChanged<String>? onSearchChanged;

  const _ExploreHeaderWithBlocBody({
    this.onSchoolEdit,
    this.onSubjectEdit,
    this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExploreHeaderBloc, ExploreHeaderState>(
      builder: (context, state) {
        final bloc = context.read<ExploreHeaderBloc>();
        return ExploreHeader(
          schoolName: state.schoolName,
          subjectName: state.subjectName,
          documentCount: state.documentCount,
          userCount: state.userCount,
          searchText: state.searchText,
          onSchoolEdit: onSchoolEdit,
          onSubjectEdit: onSubjectEdit,
          onSearchChanged: (value) {
            bloc.add(ExploreSearchChanged(value));
            onSearchChanged?.call(value);
          },
        );
      },
    );
  }
}

