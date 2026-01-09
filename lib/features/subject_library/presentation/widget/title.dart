import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/utils/responsive_helper.dart';
import 'package:studydocs/core/constants/app_colors.dart';
import 'package:studydocs/features/subject_library/logic/subject_library_state.dart';
import '../../logic/subject_library_bloc.dart';
import '../../logic/subject_library_event.dart';

class TitleSubjectLibrary extends StatefulWidget {
  final SubjectLibraryLoaded state;
  final double fontSize;
  final String schoolName;
  
  const TitleSubjectLibrary(
    this.state, {
    required this.fontSize,
    required this.schoolName,
    super.key,
  });

  @override
  State<TitleSubjectLibrary> createState() => _TitleSubjectLibraryState();
}

class _TitleSubjectLibraryState extends State<TitleSubjectLibrary> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Container(
      margin: EdgeInsets.all(responsive.isMobile ? 8 : responsive.isTablet ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tên trường
          Text(
            widget.schoolName,
            style: TextStyle(
              fontSize: responsive.fontSize(widget.fontSize),
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),

          SizedBox(height: responsive.heightPercent(2)),

          // Search bar lớn - full width
          SearchBar(
            controller: _searchController,
            backgroundColor: WidgetStateProperty.all(Colors.white),
            side: WidgetStateProperty.all(
              BorderSide(color: AppColors.headerForeground, width: 1.5),
            ),
            elevation: WidgetStateProperty.all(0),
            hintText: 'Tìm trong ${widget.schoolName}...',
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            trailing: <Widget>[
              IconButton(
                onPressed: () {
                  final query = _searchController.text.trim();
                  if (query.isNotEmpty) {
                    context.read<SubjectLibraryBloc>().add(
                      FindDocument(query),
                    );
                  }
                },
                icon: Icon(
                  Icons.search,
                  color: AppColors.headerForeground,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
