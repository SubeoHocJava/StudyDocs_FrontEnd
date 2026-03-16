import 'dart:async';

import 'package:studydocs/sceens/user/document/domain/entity/document.dart';
import 'package:studydocs/sceens/user/document/domain/entity/author.dart';
import 'package:studydocs/sceens/user/document/domain/entity/course.dart';
import 'package:studydocs/sceens/user/document/domain/entity/school.dart';

abstract interface class DocumentRepository {
  Future<Document> getById(String id);
}

class DocumentRepositoryImpl implements DocumentRepository {
  @override
  Future<Document> getById(String id) async {
    await Future.delayed(const Duration(seconds: 2));

    return Document(
      id: id,
      title: "Final Exam Mathematics 2024",

      school: const School(
        id: "school_1",
        name: "Ho Chi Minh University of Technology",
      ),

      course: const Course(
        id: "course_1",
        name: "Mathematics",
      ),

      startYear: 2023,
      endYear: 2024,
      pageNumber: 120,

      likeCount: 256,
      dislikeCount: 12,

      isLiked: false,
      isDisliked: false,
      isSaved: true,

      author: Author(
        id: "author_1",
        avatarUrl:
        "https://i.pravatar.cc/150?img=3",
        fullName: "Nguyen Van A",
        school: const School(
          name: "Ho Chi Minh University of Technology", id: '',
        ),
      ),
    );
  }
}