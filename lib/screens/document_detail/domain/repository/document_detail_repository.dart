import 'package:studydocs/screens/document_detail/domain/entity/document_detail_data.dart';

abstract interface class DocumentDetailRepository {
  Future<DocumentDetailData> getDocumentDetail(String documentId);
}
