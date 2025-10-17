import 'package:flutter/material.dart';
import 'package:studydocs/features/library/widget/library_widgets.dart';
import 'package:studydocs/features/subject_library/logic/subject_library_state.dart';

class TitleSubjectLibrary extends StatelessWidget {
  final SubjectLibraryLoaded state;
  const TitleSubjectLibrary( this.state);

  // const TitleSubjectLibrary(SubjectLibraryLoaded state);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Trường đại học nông lâm TP. Hồ Chí Minh",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          Text(
            "Công nghệ phần mềm",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              Icon(Icons.file_present, size: 16),
              Text("46"),
              SizedBox(width: 16),
              Icon(Icons.people, size: 16),
              Text("46"),
              SizedBox(width: 16),
              SizedBox(
                width: 200,   // chiều rộng
                height: 40,   // chiều cao
                child: SearchInput(
                  onSearch: () {
                    print("Search tapped");
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
