import 'package:flutter/cupertino.dart';
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
    return BlocBuilder(
      builder: (context, state) {
        if (state is DocumentInformationLoaded) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Năm học
                  Text(
                    "Năm học: ${state.documentInfo.startYear} / ${state.documentInfo.endYear}",
                  ),
                  //Số trang
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        AppAssets.numPages,
                        width: 20,
                        height: 20,
                        color: AppColors.black,
                      ),
                      Text("${state.documentInfo.pageNumber}trang "),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text("Đăng tải bởi:"),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //Ảnh đại diện
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      state.documentInfo.author.avatarUrl,
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tên người dùng
                      Text(state.documentInfo.author.fullName),
                      //Tên trường
                      InkWell(
                        onTap: () {
                          context.read<DocumentInformationBloc>().add(
                            SchoolClick(state.documentInfo.author.school.id),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              AppAssets.school,
                              width: 20,
                              height: 20,
                            ),
                            Text(
                              state.documentInfo.author.school.name,
                              style: TextStyle(color: AppColors.gray),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Like
                  OutlinedButton(
                    onPressed: () {
                      context.read<DocumentInformationBloc>().add(
                        DocumentLikeRequested(state.documentInfo.id),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          AppAssets.like,
                          width: 20,
                          height: 20,
                          color:
                              state.documentInfo.isLiked
                                  ? AppColors.primary
                                  : AppColors.black,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          state.documentInfo.likeCount.toString(),
                          style: TextStyle(
                            color:
                                state.documentInfo.isLiked
                                    ? AppColors.primary
                                    : AppColors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  //Dislike
                  OutlinedButton(
                    onPressed: () {
                      context.read<DocumentInformationBloc>().add(
                        DocumentDislikeRequested(state.documentInfo.id),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          AppAssets.like,
                          width: 20,
                          height: 20,
                          color:
                          state.documentInfo.isDisliked
                              ? AppColors.primary
                              : AppColors.black,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          state.documentInfo.dislikeCount.toString(),
                          style: TextStyle(
                            color:
                            state.documentInfo.isDisliked
                                ? AppColors.primary
                                : AppColors.black,
                          ),
                        ),
                      ],
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
