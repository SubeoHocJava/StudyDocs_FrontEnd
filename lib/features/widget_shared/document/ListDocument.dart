
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../model/Document.dart';

class ListDocument extends StatelessWidget{
  final List<Document>documents;
  const ListDocument(this.documents);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   return ListView.builder(
     shrinkWrap: true,
     physics: NeverScrollableScrollPhysics(),
     itemCount: documents.length,
     itemBuilder: (context, index) {
       return Padding(
         padding: const EdgeInsets.symmetric(
           vertical: 4.0,
           horizontal: 16.0,
         ),
         child: MonoDocumentInList(
           document: documents[index],
         ),
       );
     },
   );
  }
  
}
class MonoDocumentInList extends StatelessWidget {
  final Document document;
  const MonoDocumentInList({super.key, required this.document});
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;//screen size
    return Container(
      width: screenWidth*0.9,
      padding: EdgeInsets.all(screenWidth*0.05),
      margin: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        // color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            "assets/icons/temp_image.jpg",
            width: screenWidth * 0.3,
            height: screenWidth * 0.3,
          ),
          SizedBox(width: 4,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  document.title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),

                // subject
                Row(
                  children: [
                    Icon(Icons.folder, size: 16, color: Colors.blue),
                    SizedBox(width: 4),
                    Text(document.subject),
                  ],
                ),
                SizedBox(height: 4),

                // school
                Row(
                  children: [
                    Image.asset("assets/icons/school.png", width: 16, height: 16),
                    SizedBox(width: 4),
                    Text(document.school),
                  ],
                ),
                SizedBox(height: 4),

                // page and date
                Row(
                  children: [
                    Icon(Icons.file_open_rounded, size: 16),
                    SizedBox(width: 4),
                    Text("${document.pages} trang"), // ✅ int -> String
                    SizedBox(width: 12),
                    Icon(Icons.calendar_today, size: 16),
                    SizedBox(width: 4),
                    Text(document.date),
                  ],
                ),
                SizedBox(height: 4),
                // like and comment
                Row(
                  children: [
                    Icon(Icons.favorite, size: 16, color: Colors.red),
                    SizedBox(width: 4),
                    Text("${document.likes}"), // ✅ int -> String
                    SizedBox(width: 12),
                    Icon(Icons.comment, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Text("${document.comments}"), // ✅ int -> String
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}