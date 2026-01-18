import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/utils/responsive_helper.dart';
import 'package:studydocs/core/network/dio_client.dart';
import 'package:studydocs/data/datasource/impl/academic_remote_datasource_impl.dart';
import 'package:studydocs/features/subject_library/domain/entity/subject_entity.dart';

import '../../logic/upload_file_bloc.dart';
import '../../logic/upload_file_event.dart';
import '../../logic/upload_file_state.dart';

class SubjectLabel extends StatelessWidget {
  final String subject;
  final String? subjectId;
  final String? schoolId;

  const SubjectLabel({
    super.key,
    required this.subject,
    this.subjectId,
    this.schoolId,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final canSelect = schoolId != null && schoolId!.isNotEmpty;

    return Center(
      child: Container(
        width: responsive.widthPercent(responsive.isMobile ? 80 : 160),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.folder, size: responsive.fontSize(20)),
                SizedBox(width: responsive.widthPercent(2)),
                Expanded(
                  child: Text(
                    "Môn học",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: responsive.fontSize(18),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: canSelect 
                      ? () => _showSubjectPicker(context)
                      : () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Vui lòng chọn trường học trước'),
                            ),
                          );
                        },
                  child: Text(
                    "Chỉnh sửa",
                    style: TextStyle(
                      fontSize: responsive.fontSize(14),
                      color: canSelect ? Colors.blueAccent : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: canSelect
                  ? () => _showSubjectPicker(context)
                  : () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Vui lòng chọn trường học trước'),
                        ),
                      );
                    },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.widthPercent(3),
                  vertical: responsive.heightPercent(1),
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: canSelect ? Colors.grey.shade300 : Colors.grey.shade200,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  color: canSelect ? Colors.white : Colors.grey.shade100,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        subject.isEmpty ? "Chọn môn học" : subject,
                        style: TextStyle(
                          color: subject.isEmpty
                              ? Colors.grey
                              : canSelect
                                  ? Colors.blue
                                  : Colors.grey,
                          fontSize: responsive.fontSize(16),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      color: canSelect ? Colors.grey : Colors.grey.shade400,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSubjectPicker(BuildContext context) {
    if (schoolId == null || schoolId!.isEmpty) return;

    final academicDataSource = AcademicRemoteDataSourceImpl(
      dioClient: context.read<DioClient>(),
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (modalContext) {
        return _SubjectPickerModal(
          academicDataSource: academicDataSource,
          schoolId: schoolId!,
          onSelect: (subject) {
            context.read<UploadFileBloc>().add(
              SelectSubject(subject.id, subject.name),
            );
          },
        );
      },
    );
  }
}

class _SubjectPickerModal extends StatefulWidget {
  final AcademicRemoteDataSourceImpl academicDataSource;
  final String schoolId;
  final Function(SubjectEntity) onSelect;

  const _SubjectPickerModal({
    required this.academicDataSource,
    required this.schoolId,
    required this.onSelect,
  });

  @override
  State<_SubjectPickerModal> createState() => _SubjectPickerModalState();
}

class _SubjectPickerModalState extends State<_SubjectPickerModal> {
  final TextEditingController _searchCtrl = TextEditingController();
  List<SubjectEntity> _allSubjects = [];
  List<SubjectEntity> _filteredSubjects = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadSubjects();
  }

  void _loadSubjects() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final subjects = await widget.academicDataSource.getSubjectsBySchool(widget.schoolId);
      if (mounted) {
        setState(() {
          _allSubjects = subjects;
          _filteredSubjects = subjects;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _errorMessage = e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _filterSubjects(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredSubjects = _allSubjects;
      } else {
        _filteredSubjects = _allSubjects
            .where((s) => s.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            "Chọn môn học",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _searchCtrl,
            decoration: const InputDecoration(
              hintText: "Tìm kiếm môn học...",
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: (val) => _filterSubjects(val),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                    ? Center(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _filteredSubjects.length,
                        itemBuilder: (context, index) {
                          final subject = _filteredSubjects[index];
                          return ListTile(
                            title: Text(subject.name),
                            onTap: () {
                              widget.onSelect(subject);
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
