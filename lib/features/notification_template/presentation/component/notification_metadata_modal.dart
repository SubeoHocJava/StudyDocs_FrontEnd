import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/features/notification_template/logic/notification_template_bloc.dart';
import 'package:studydocs/features/notification_template/logic/notification_template_state.dart';

class NotificationMetadataModal extends StatelessWidget {
  final Function(String label, String key) onSelect;

  const NotificationMetadataModal({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
       padding: const EdgeInsets.symmetric(vertical: 20),
       height: MediaQuery.of(context).size.height * 0.7,
       child: Column(
         children: [
            Padding(
               padding: const EdgeInsets.symmetric(horizontal: 16),
               child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     const Text('Chọn từ khóa', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                     IconButton(
                       icon: const Icon(Icons.close),
                       onPressed: () => Navigator.pop(context),
                       padding: EdgeInsets.zero,
                       constraints: const BoxConstraints(),
                     )
                  ],
               ),
            ),
            const Divider(),
            Expanded(
              child: BlocBuilder<NotificationTemplateBloc, NotificationTemplateState>(
                builder: (context, state) {
                  if (state.keywords.isEmpty) {
                     return const Center(child: Text("Không có từ khóa nào"));
                  }
                  return ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: state.keywords.map((group) {
                       return Theme(
                         data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                         child: ExpansionTile(
                           title: Text(
                             group.name, 
                             style: TextStyle(
                               fontSize: 14, 
                               fontWeight: FontWeight.w500,
                               color: Colors.grey.shade700
                             )
                           ),
                           tilePadding: EdgeInsets.zero,
                           childrenPadding: const EdgeInsets.only(bottom: 12),
                           initiallyExpanded: false,
                           children: group.keywords.map((k) => _buildItem(context, k.label, k.key)).toList(),
                         ),
                       );
                    }).toList(),
                  );
                }
              ),
            ),
         ],
       ),
    );
  }

  Widget _buildItem(BuildContext context, String label, String key) {
    return InkWell(
      onTap: () {
        onSelect(label, key);
        Navigator.pop(context);
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
           children: [
              Expanded(
                child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
              ),
              const Icon(Icons.add, color: Colors.blue, size: 20),
           ],
        ),
      ),
    );
  }
}
