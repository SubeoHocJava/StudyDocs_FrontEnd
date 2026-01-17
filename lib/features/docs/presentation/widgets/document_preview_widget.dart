import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DocumentPreviewWidget extends StatefulWidget {
  final List<String> previewUrls;
  final bool initialExpanded;
  final VoidCallback? onExpand;

  const DocumentPreviewWidget({
    super.key,
    required this.previewUrls,
    this.initialExpanded = false,
    this.onExpand,
  });

  @override
  State<DocumentPreviewWidget> createState() => _DocumentPreviewWidgetState();
}

class _DocumentPreviewWidgetState extends State<DocumentPreviewWidget> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initialExpanded;
  }



  // Allow parent to control state/listen
  @override
  void didUpdateWidget(covariant DocumentPreviewWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialExpanded != oldWidget.initialExpanded) {
        _isExpanded = widget.initialExpanded;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.previewUrls.isEmpty) {
        return Container(
            height: 200,
            color: Colors.grey.shade100,
            alignment: Alignment.center,
            child: const Text("Chưa có bản xem trước"),
        );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 400, // Fixed height for preview area
          child: PageView.builder(
            itemCount: _isExpanded ? widget.previewUrls.length : 1,
            physics: _isExpanded ? null : const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300),
                  color: Colors.white,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CachedNetworkImage(
                    imageUrl: widget.previewUrls[index],
                    fit: BoxFit.contain, // Show full page content
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => const Center(
                        child: Icon(Icons.error, size: 50, color: Colors.red)),
                  ),
                ),
              );
            },
          ),
        ),
        if (!_isExpanded)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 8),
            child: OutlinedButton.icon(
              onPressed: () {
                setState(() {
                  _isExpanded = true;
                });
                if (widget.onExpand != null) {
                    widget.onExpand!();
                }
              },
              icon: const Icon(Icons.expand_more),
              label: const Text("Xem thêm chi tiết"),
            ),
          ),
      ],
    );
  }
}
