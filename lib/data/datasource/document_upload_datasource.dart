import 'dart:async';

import 'package:studydocs/core/widgets/feat/document/upload_form/domain/entity/school.dart';
import 'package:studydocs/core/widgets/feat/document/upload_form/domain/entity/subject.dart';
import 'package:studydocs/core/widgets/feat/document/upload_form/domain/repository/upload_repository.dart';

/// Fake datasource cho form upload tài liệu.
/// Dùng dữ liệu mẫu thay vì gọi API thật.
class DocumentUploadDatasource implements UploadRepository {
  DocumentUploadDatasource();

  static const List<School> _schools = [
    School(id: 'nlu', name: 'Trường Đại học Nông Lâm Tp. HCM'),
    School(id: 'uit', name: 'Trường Đại học Công nghệ Thông tin'),
    School(id: 'hutech', name: 'Trường Đại học Công nghệ Tp. HCM'),
  ];

  static const List<Subject> _subjects = [
    Subject(id: 'nlu-it', schoolId: 'nlu', name: 'Công nghệ thông tin'),
    Subject(id: 'nlu-net', schoolId: 'nlu', name: 'Lập trình .NET'),
    Subject(id: 'nlu-web', schoolId: 'nlu', name: 'Lập trình Web'),
    Subject(id: 'uit-cs', schoolId: 'uit', name: 'Khoa học máy tính'),
    Subject(id: 'uit-se', schoolId: 'uit', name: 'Kỹ thuật phần mềm'),
    Subject(id: 'hutech-mkt', schoolId: 'hutech', name: 'Marketing'),
    Subject(id: 'hutech-biz', schoolId: 'hutech', name: 'Quản trị kinh doanh'),
  ];

  @override
  Future<List<School>> getSchools() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _schools;
  }

  @override
  Future<List<Subject>> getSubjectsBySchool(String schoolId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _subjects.where((s) => s.schoolId == schoolId).toList();
  }

  @override
  Future<void> submitUpload(UploadRequest request) async {
    // Demo: giả lập submit thành công sau 500ms.
    await Future.delayed(const Duration(milliseconds: 500));
  }
}

