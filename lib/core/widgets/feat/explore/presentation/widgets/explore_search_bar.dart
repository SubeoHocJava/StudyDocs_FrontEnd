import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/constants/app_colors.dart';
import 'package:studydocs/screens/explore/logic/explore_bloc.dart';
import 'package:studydocs/screens/explore/logic/explore_event.dart';
import 'package:studydocs/core/widgets/feat/search/presentation/voice_search_bottom_sheet.dart';

class ExploreSearchBar extends StatefulWidget {
  final String hintText;
  final String? initialQuery;

  const ExploreSearchBar({
    super.key,
    required this.hintText,
    this.initialQuery,
  });

  @override
  State<ExploreSearchBar> createState() => _ExploreSearchBarState();
}

class _ExploreSearchBarState extends State<ExploreSearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSubmitted(String value) {
    context.read<ExploreBloc>().add(SearchExploreEvent(value));
  }

  void _onClear() {
    _controller.clear();
    context.read<ExploreBloc>().add(SearchExploreEvent(''));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: TextField(
        controller: _controller,
        onSubmitted: _onSubmitted,
        onChanged: (val) {
          // Xoá hết → quay về trang mặc định ngay lập tức
          if (val.isEmpty) _onClear();
          setState(() {});
        },
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(color: AppColors.grey.shade500, fontSize: 14),
          prefixIcon: Icon(Icons.search, color: AppColors.primary, size: 22),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close, size: 20, color: AppColors.grey),
                  onPressed: _onClear,
                )
              : IconButton(
                  icon: Icon(Icons.mic, size: 20, color: Theme.of(context).iconTheme.color),
                  onPressed: () async {
                    final result = await showModalBottomSheet<String>(
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (_) => const VoiceSearchBottomSheet(),
                    );
                    if (!mounted) return;
                    
                    if (result != null && result.isNotEmpty) {
                      _controller.text = result;
                      _onSubmitted(result);
                    }
                  },
                ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          filled: true,
          fillColor: Theme.of(context).cardColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: AppColors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: AppColors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: AppColors.primary, width: 1.5),
          ),
        ),
      ),
    );
  }
}
