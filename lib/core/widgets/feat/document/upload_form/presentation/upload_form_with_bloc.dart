import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:studydocs/core/widgets/feat/document/upload_form/domain/repository/upload_repository.dart';
import 'package:studydocs/core/widgets/feat/document/upload_form/domain/usecase/get_school_list_usecase.dart';
import 'package:studydocs/core/widgets/feat/document/upload_form/domain/usecase/get_subject_list_usecase.dart';
import 'package:studydocs/core/widgets/feat/document/upload_form/logic/document_upload_bloc.dart';
import 'package:studydocs/core/widgets/feat/document/upload_form/logic/document_upload_event.dart';
import 'package:studydocs/core/widgets/feat/document/upload_form/logic/document_upload_state.dart';
import 'package:studydocs/core/widgets/feat/document/upload_form/presentation/upload_form.dart';

/// Widget gom Bloc cho form upload.
/// Các page (admin, v.v.) chỉ cần:
/// UploadFormWithBloc(repository: someUploadRepository)
class UploadFormWithBloc extends StatelessWidget {
  final UploadRepository repository;
  final String? initialFileName;
  final String? initialFilePath;

  const UploadFormWithBloc({
    super.key,
    required this.repository,
    this.initialFileName,
    this.initialFilePath,
  });

  @override
  Widget build(BuildContext context) {
    final getSchoolListUseCase = GetSchoolListUseCaseImpl(repository);
    final getSubjectListUseCase = GetSubjectListUseCaseImpl(repository);

    return BlocProvider(
      create: (_) => DocumentUploadBloc(
        getSchoolListUseCase: getSchoolListUseCase,
        getSubjectListUseCase: getSubjectListUseCase,
      )..add(
          UploadInitialized(
            initialFileName: initialFileName,
            initialFile:
                initialFilePath != null ? File(initialFilePath!) : null,
          ),
        ),
      child: const _UploadFormWithBlocBody(),
    );
  }
}

class _UploadFormWithBlocBody extends StatelessWidget {
  const _UploadFormWithBlocBody();

  @override
  Widget build(BuildContext context) {
    return BlocListener<DocumentUploadBloc, DocumentUploadState>(
      listenWhen: (prev, curr) => curr.errorMessage != null,
      listener: (context, state) {
        final message = state.errorMessage;
        if (message != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
          context.read<DocumentUploadBloc>().add(const UploadErrorCleared());
        }
      },
      child: BlocBuilder<DocumentUploadBloc, DocumentUploadState>(
        builder: (context, state) {
          if (state.isLoading && state.schools.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          final bloc = context.read<DocumentUploadBloc>();
          return UploadForm(
            fileName: state.fileName,
            selectedSchool: state.selectedSchool,
            selectedSubject: state.selectedSubject,
            onPickFile: () async {
              final result = await FilePicker.platform.pickFiles();
              final file =
                  (result != null && result.files.isNotEmpty) ? result.files.first : null;
              final path = file?.path;
              if (file == null || path == null) {
                return;
              }
              bloc.add(UploadFilePicked(file.name, File(path)));
            },
            onChangeSchool: () {
              // Demo: xoay vòng qua danh sách trường khi bấm "Chỉnh sửa".
              final schools = state.schools;
              if (schools.isEmpty) {
                return;
              }
              final current = state.selectedSchool;
              final currentIndex =
                  current != null ? schools.indexOf(current) : -1;
              final nextIndex = (currentIndex + 1) % schools.length;
              final nextSchool = schools[nextIndex];
              bloc.add(UploadSchoolChanged(nextSchool.id));
            },
            onChangeSubject: () {
              // Demo: xoay vòng qua danh sách môn khi bấm "Chỉnh sửa".
              final subjects = state.subjects;
              if (subjects.isEmpty) {
                return;
              }
              final current = state.selectedSubject;
              final currentIndex =
                  current != null ? subjects.indexOf(current) : -1;
              final nextIndex = (currentIndex + 1) % subjects.length;
              final nextSubject = subjects[nextIndex];
              bloc.add(UploadSubjectChanged(nextSubject.id));
            },
            onSubmit: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Demo submit form upload (chưa gọi API)'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

