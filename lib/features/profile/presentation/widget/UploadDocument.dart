import 'package:flutter/cupertino.dart';
import 'package:studydocs/core/utils/responsive_helper.dart';
import 'package:studydocs/core/widgets/document/model/row_document_ui.dart';
import 'package:studydocs/features/profile/domain/model/document_profile.dart';
import '../../../../core/widgets/document/RowDocument.dart';
import '../../logic/profile_state.dart';

class UpLoadDocument extends StatelessWidget {
  final ProfileLoaded state;
  final void Function(RowDocumentItem)? onTap;

  const UpLoadDocument({
    super.key,
    required this.state,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final List<DocumentProfile> documents = state.documents;
    // Số cột theo thiết bị
    final crossAxisCount = responsive.getGridColumnCount(
      mobile: 3,
      tablet: 4,
      desktop: 5,
    );

    // Card width theo số cột
    final cardWidth = responsive.getCardWidth(
      columns: crossAxisCount,
      spacing: 12,
      padding: 16,
    );

    return Padding(
      padding: responsive.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Tài liệu bạn tải lên",
            style: TextStyle(
              fontSize: responsive.fontSize(20),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),


          RowDocument(
            documents.cast<RowDocumentItem>(),
            cardWidth: cardWidth,
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}
