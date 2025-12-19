import '../../library/data/model/Document.dart';
import '../domain/entity/DocumentEntity.dart';

extension DocumentMapper on DocumentEntity {
  Document toUIModel() {
    return Document(
      title: title,
      subject: subject,
      school: school,
      pages: pages,
      date: date,
      likes: 0,      // vì DocumentEntity chưa có likes
      comments: 0,   // vì DocumentEntity chưa có comments
    );
  }
}
