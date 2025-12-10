// import 'package:flutter/material.dart';
// import '../constants/app_colors.dart';
// import '../constants/app_icons.dart';
// import 'app_icon_button.dart';
//
// class DocItemVertical extends StatelessWidget {
//   final String title;
//   final String author;
//   final VoidCallback? onTap;
//
//   const DocItemVertical({
//     super.key,
//     required this.title,
//     required this.author,
//     this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap ?? () {},
//       child: Container(
//         width: 160,
//         margin: const EdgeInsets.only(right: 12),
//         padding: const EdgeInsets.all(10),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           border: Border.all(color: AppColors.docTitleBorder, width: 1),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // thumbnail giả
//             Container(
//               height: 80,
//               decoration: BoxDecoration(
//                 color: AppColors.headerBg,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               alignment: Alignment.center,
//               child: Image.asset(AppAssets.folder, width: 30, height: 30, color: AppColors.headerFg),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               title,
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//               style: const TextStyle(
//                 color: AppColors.docTitleBorder,
//                 fontSize: 14,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               author,
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//               style: const TextStyle(
//                 color: AppColors.docSmallText,
//                 fontSize: 12,
//               ),
//             ),
//             const Spacer(),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: const [
//                 AppIconButton(assetPath: AppAssets.like,     onPressed: null, size: 20),
//                 AppIconButton(assetPath: AppAssets.cmt,      onPressed: null, size: 20),
//                 AppIconButton(assetPath: AppAssets.download, onPressed: null, size: 20),
//                 AppIconButton(assetPath: AppAssets.saved,    onPressed: null, size: 20),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
