import 'package:flutter/material.dart';
import 'package:studydocs/core/widgets/feat/document/docs_card/presentation/document_card_horizontal.dart';
import 'package:studydocs/screens/user/home/presentation/home_screen.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    ),
  );
//  runApp(MaterialApp(
//     home: Scaffold(
//       backgroundColor: Colors.grey[100],
//       body: Padding(
//         padding: EdgeInsets.all(16),
//         child: DocumentCardHorizontal(),  
//       ),
//     ),
//   ));
}
