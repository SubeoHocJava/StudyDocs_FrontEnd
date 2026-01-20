import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/features/notification_template/logic/notification_template_bloc.dart';
import 'package:studydocs/features/notification_template/logic/notification_template_state.dart';

class NotificationTemplateHeader extends StatefulWidget {
  final String searchQuery;
  final String? selectedType;
  final String? selectedChannel;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String?> onTypeChanged;
  final ValueChanged<String?> onChannelChanged;
  final VoidCallback onAddPressed;

  const NotificationTemplateHeader({
    super.key,
    required this.searchQuery,
    required this.selectedType,
    required this.selectedChannel,
    required this.onSearchChanged,
    required this.onTypeChanged,
    required this.onChannelChanged,
    required this.onAddPressed,
  });

  @override
  State<NotificationTemplateHeader> createState() => _NotificationTemplateHeaderState();
}

class _NotificationTemplateHeaderState extends State<NotificationTemplateHeader> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: TextField(
                    onChanged: widget.onSearchChanged,
                    decoration: InputDecoration(
                      hintText: "Tìm kiếm mẫu thông báo",
                      hintStyle: TextStyle(color: Theme.of(context).hintColor, fontWeight: FontWeight.normal),
                      prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.primary),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      filled: true,
                      fillColor: Theme.of(context).inputDecorationTheme.fillColor ?? Theme.of(context).cardTheme.color,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: widget.onAddPressed,
                  icon: Icon(Icons.add, color: Theme.of(context).colorScheme.onPrimary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                 // Nhãn bộ lọc
                 const Text("Lọc theo: ", style: TextStyle(fontWeight: FontWeight.w500)),
                 const SizedBox(width: 8),
                  // Bộ lọc loại

                 BlocBuilder<NotificationTemplateBloc, NotificationTemplateState>(
                   buildWhen: (previous, current) => previous.categories != current.categories,
                   builder: (context, state) {
                     final selectedCategoryName = state.categories
                         .where((e) => e.code == widget.selectedType)
                         .firstOrNull
                         ?.name;
                     return _buildFilterChip(
                        context, 
                        label: selectedCategoryName ?? 'Tất cả loại',
                        isSelected: widget.selectedType != null,
                        onTap: () {
                           _showFilterOptions(
                             context, 
                             'Loại', 
                             state.categories, 
                             widget.onTypeChanged,
                             (e) => e.name,
                             (e) => e.code
                           );
                        },
                        onClear: () {
                             widget.onTypeChanged(null);
                        }
                     );
                   }
                 ),
                 const SizedBox(width: 8),
                 // Bộ lọc kênh

                 BlocBuilder<NotificationTemplateBloc, NotificationTemplateState>(
                   buildWhen: (previous, current) => previous.channels != current.channels,
                   builder: (context, state) {
                     final selectedChannelName = state.channels
                         .where((e) => e.code == widget.selectedChannel)
                         .firstOrNull
                         ?.name;
                     return _buildFilterChip(
                        context, 
                        label: selectedChannelName ?? 'Tất cả kênh',
                        isSelected: widget.selectedChannel != null,
                        onTap: () {
                           _showFilterOptions(
                             context, 
                             'Kênh', 
                             state.channels, 
                             widget.onChannelChanged,
                             (e) => e.name,
                             (e) => e.code
                           );
                        },
                        onClear: () {
                             widget.onChannelChanged(null);
                        }
                     );
                   }
                 ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, {required String label, required bool isSelected, required VoidCallback onTap, required VoidCallback onClear}) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
           decoration: BoxDecoration(
             color: isSelected ? Theme.of(context).primaryColorLight : Theme.of(context).cardTheme.color,
             borderRadius: BorderRadius.circular(20),
             border: Border.all(color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).dividerColor),
           ),
           child: Row(
             children: [
               Text(
                 label, 
                 style: TextStyle(
                   color: isSelected ? Theme.of(context).primaryColorDark : Theme.of(context).textTheme.bodyLarge?.color,
                   fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal
                 )
               ),
               if (isSelected) ...[
                 const SizedBox(width: 4),
                 GestureDetector(
                   onTap: onClear,
                   child: Icon(Icons.close, size: 16, color: Theme.of(context).primaryColorDark),
                 )
               ] else ...[
                 const SizedBox(width: 4),
                 Icon(Icons.arrow_drop_down, size: 18, color: Theme.of(context).iconTheme.color),
               ]
             ],
           ),
        ),
      );
  }

  void _showFilterOptions<T>(
    BuildContext context, 
    String title, 
    List<T> options, 
    ValueChanged<String?> onSelect,
    String Function(T) getName,
    String Function(T) getCode,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Chọn $title", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ActionChip(
                    label: const Text("Tất cả"),
                    onPressed: () {
                      onSelect(null);
                      Navigator.pop(context);
                    },
                  ),
                  ...options.map((opt) => ActionChip(
                    label: Text(getName(opt)),
                    onPressed: () {
                      onSelect(getCode(opt));
                      Navigator.pop(context);
                    },
                  )),
                ],
              )
            ],
          ),
        );
      }
    );
  }
}
