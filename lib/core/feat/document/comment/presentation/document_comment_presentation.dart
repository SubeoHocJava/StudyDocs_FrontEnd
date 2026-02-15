
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:studydocs/core/constants/app_colors.dart';
import 'package:studydocs/core/constants/app_icons.dart';
import 'package:studydocs/core/feat/document/comment/domain/entity/content.dart';
import 'package:studydocs/core/feat/document/comment/logic/document_comment_bloc.dart';
import 'package:studydocs/core/feat/document/comment/logic/document_comment_event.dart';
import 'package:studydocs/core/feat/document/comment/logic/document_comment_state.dart';
import 'package:studydocs/core/utils/date_time_utils.dart';

class DocumentCommentPresentation extends StatefulWidget {
  final String documentId;

  const DocumentCommentPresentation({super.key, required this.documentId});

  @override
  State<DocumentCommentPresentation> createState() =>
      _DocumentCommentPresentationState();
}

class _DocumentCommentPresentationState
    extends State<DocumentCommentPresentation> {
  final TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    final content = _controller.text.trim();
    if (content.isNotEmpty) {
      context.read<DocumentCommentBloc>().add(
            CommentRequested(content, widget.documentId),
          );
      _controller.clear();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Text(
                'Bình luận',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
        ),
        // Content
        Expanded(
          child: BlocBuilder<DocumentCommentBloc, DocumentCommentState>(
            builder: (context, state) {
              if (state is DocumentCommentLoaded) {
                if (state.comments.isEmpty) {
                  return Center(child: Text("Chưa có bình luận nào."));
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.comments.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final comment = state.comments[index];
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Avatar
                        GestureDetector(
                          onTap: () {
                            context.read<DocumentCommentBloc>().add(
                                  AuthorClick(comment.author.id),
                                );
                          },
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: AppColors.backgroundLight,
                            child: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: comment.author.avatarUrl,
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                  AppAssets.avt,
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                ),
                                fit: BoxFit.cover,
                                width: 40,
                                height: 40,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Content
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      comment.author.fullName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.black,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      DateTimeUtils.formatTimeAgo(
                                        comment.createdAt,
                                      ),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.gray,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                if (comment.contents.isNotEmpty &&
                                    comment.contents.first is TextBlock)
                                  Text(
                                    (comment.contents.first as TextBlock).text,
                                    style: TextStyle(
                                      color: AppColors.black,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
        ),
        // Input Area
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            color: AppColors.white,
            border: Border(top: BorderSide(color: AppColors.border)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundLight,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Bạn nghĩ gì về tài liệu này.',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: AppColors.gray),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: _sendMessage,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryBlue,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        FontAwesomeIcons.paperPlane,
                        color: AppColors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Gửi',
                        style: TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
