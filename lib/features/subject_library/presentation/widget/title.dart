import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/utils/responsive_helper.dart';
import 'package:studydocs/features/subject_library/logic/subject_library_state.dart';
import '../../../library/presentation/widget/library_widgets.dart';
import '../../logic/subject_library_bloc.dart';
import '../../logic/subject_library_event.dart';

class TitleSubjectLibrary extends StatelessWidget {
  final SubjectLibraryLoaded state;
  final double fontSize; // fontSize base
  const TitleSubjectLibrary(this.state, {required this.fontSize, super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final school=state.school;
    final subject=state.subject;
    final num_docs=state.num_docs;
    final num_friends=state.num_docs;

    return Container(
      margin: EdgeInsets.all(responsive.isMobile ? 8 : responsive.isTablet ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tên trường
          Text(
           school,
            style: TextStyle(
              fontSize: responsive.fontSize(fontSize), // responsive font
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),

          SizedBox(height: responsive.heightPercent(1)),

          // Ngành học
          Text(
           subject,
            style: TextStyle(
              fontSize: responsive.fontSize(fontSize + 5), // lớn hơn một chút
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: responsive.heightPercent(2)),

          // Row icon + search
          Row(
            children: [
              Icon(Icons.file_present, size: responsive.fontSize(16)),
              SizedBox(width: responsive.widthPercent(2)),
              Text(num_docs.toString(), style: TextStyle(fontSize: responsive.fontSize(14))),

              SizedBox(width: responsive.widthPercent(4)),

              Icon(Icons.people, size: responsive.fontSize(16)),
              SizedBox(width: responsive.widthPercent(2)),
              Text(num_friends.toString(), style: TextStyle(fontSize: responsive.fontSize(14))),

              SizedBox(width: responsive.widthPercent(4)),

              // Search box responsive
              SizedBox(
                width: responsive.widthPercent( 60 ),
                height: 40,
                child: SearchInput(
                  onSearch: () {
                   context.read<SubjectLibraryBloc>().add(SubjectLibraryLoadDocumentByKeyWord("keyword"));
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: responsive.heightPercent(2)),
          // ĐƯỜNG LINE CUỐI
          Divider(
            thickness: 1,
            color: Colors.grey.shade300,
          ),
        ],
      ),
    );
  }
}
