import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/utils/responsive_helper.dart';
import 'package:studydocs/core/network/dio_client.dart';
import 'package:studydocs/data/datasource/impl/academic_remote_datasource_impl.dart';
import 'package:studydocs/features/explore/domain/entity/school_entity.dart';

import '../../logic/upload_file_bloc.dart';
import '../../logic/upload_file_event.dart';

class SchoolLabel extends StatelessWidget {
  final String school;
  final String? schoolId;
  
  const SchoolLabel({
    super.key, 
    required this.school,
    this.schoolId,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    
    return Center(
      child: Container(
        width: responsive.widthPercent(responsive.isMobile ? 80 : 160),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.school, size: responsive.fontSize(20)),
                SizedBox(width: responsive.widthPercent(2)),
                Expanded(
                  child: Text(
                    "Trường học",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: responsive.fontSize(18),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => _showSchoolPicker(context),
                  child: Text(
                    "Chỉnh sửa",
                    style: TextStyle(
                      fontSize: responsive.fontSize(14),
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: responsive.heightPercent(1)),
            InkWell(
              onTap: () => _showSchoolPicker(context),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.widthPercent(3),
                  vertical: responsive.heightPercent(1),
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        school.isEmpty ? "Chọn trường học" : school,
                        style: TextStyle(
                          color: school.isEmpty ? Colors.grey : Colors.blue,
                          fontSize: responsive.fontSize(16),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_drop_down, color: Colors.grey),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSchoolPicker(BuildContext context) {
    final academicDataSource = AcademicRemoteDataSourceImpl(
      dioClient: context.read<DioClient>(),
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (modalContext) {
        return _SchoolPickerModal(
          academicDataSource: academicDataSource,
          onSelect: (school) {
            context.read<UploadFileBloc>().add(
              SelectSchool(school.id, school.name),
            );
          },
        );
      },
    );
  }
}

class _SchoolPickerModal extends StatefulWidget {
  final AcademicRemoteDataSourceImpl academicDataSource;
  final Function(SchoolEntity) onSelect;

  const _SchoolPickerModal({
    required this.academicDataSource,
    required this.onSelect,
  });

  @override
  State<_SchoolPickerModal> createState() => _SchoolPickerModalState();
}

class _SchoolPickerModalState extends State<_SchoolPickerModal> {
  final TextEditingController _searchCtrl = TextEditingController();
  List<SchoolEntity> _schools = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _search("");
  }

  void _search(String query) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      final results = await widget.academicDataSource.searchSchools(query);
      if (mounted) {
        setState(() => _schools = results);
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

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            "Chọn trường học",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _searchCtrl,
            decoration: const InputDecoration(
              hintText: "Tìm kiếm trường...",
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: (val) => _search(val),
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
                        itemCount: _schools.length,
                        itemBuilder: (context, index) {
                          final school = _schools[index];
                          return ListTile(
                            title: Text(school.name),
                            onTap: () {
                              widget.onSelect(school);
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
