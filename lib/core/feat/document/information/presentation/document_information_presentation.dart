import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/constants/app_colors.dart';
import 'package:studydocs/core/constants/app_icons.dart';
import 'package:studydocs/core/feat/document/information/logic/document_information_bloc.dart';
import 'package:studydocs/core/feat/document/information/logic/document_information_event.dart';
import 'package:studydocs/core/feat/document/information/logic/document_information_state.dart';

class DocumentInformationPresentation extends StatelessWidget {
  const DocumentInformationPresentation({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DocumentInformationBloc, DocumentInformationState>(
      builder: (context, state) {
        if (state is DocumentInformationLoaded) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Năm học
                  Text(
                    "Năm học: ${state.documentInfo.startYear} / ${state.documentInfo.endYear}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  //Số trang
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        AppAssets.numPages,
                        width: 20,
                        height: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "${state.documentInfo.pageNumber} trang",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                "Đăng tải bởi:",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () {
                  context.read<DocumentInformationBloc>().add(
                    AuthorClick(state.documentInfo.author.id),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    //Ảnh đại diện
                    ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Image.network(
                        state.documentInfo.author.avatarUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tên người dùng
                        Text(
                          state.documentInfo.author.fullName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        //Tên trường
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              AppAssets.school,
                              width: 16,
                              height: 16,
                              color: AppColors.gray,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              state.documentInfo.author.school.name,
                              style: const TextStyle(
                                color: AppColors.gray,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //Like
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        context.read<DocumentInformationBloc>().add(
                          DocumentLikeRequested(state.documentInfo.id),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: AppColors.border),
                        shape: const StadiumBorder(),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            state.documentInfo.isLiked
                                ? AppAssets.fullLike
                                : AppAssets.outlineLike,
                            width: 20,
                            height: 20,
                            color: state.documentInfo.isLiked
                                ? AppColors.primary
                                : AppColors.black,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            state.documentInfo.likeCount.toString(),
                            style: const TextStyle(
                              color: AppColors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  //Dislike
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        context.read<DocumentInformationBloc>().add(
                          DocumentDislikeRequested(state.documentInfo.id),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: AppColors.border),
                        shape: const StadiumBorder(),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Transform.rotate(
                            angle: 3.14159,
                            child: Image.asset(
                              state.documentInfo.isDisliked
                                  ? AppAssets.fullLike
                                  : AppAssets.outlineLike,
                              width: 20,
                              height: 20,
                              color: state.documentInfo.isDisliked
                                  ? AppColors.danger
                                  : AppColors.black,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            state.documentInfo.dislikeCount.toString(),
                            style: const TextStyle(
                              color: AppColors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          );
        } else {
          return Text("Loading...");
        }
      },
    );
  }
}
