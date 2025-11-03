import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../logic/docs_bloc.dart';
import '../logic/docs_state.dart';
import '../logic/docs_event.dart';
import 'docs_detail_screen.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_colors.dart';

class DocsScreen extends StatelessWidget {
  const DocsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<DocsBloc, DocsState>(
          builder: (context, state) {
            if (state is DocsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DocsLoaded) {
              final doc = state.docDetails;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title + mũi tên xuống mở chi tiết
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            doc["title"],
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton(
                          tooltip: 'Xem chi tiết',
                          icon: const Icon(Icons.arrow_drop_down_circle_outlined),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: BlocProvider.of<DocsBloc>(context),
                                  child: const DocsDetailScreen(),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Image.asset(AppAssets.folder, width: 20, height: 20),
                        const SizedBox(width: 6),
                        Expanded(child: Text(doc["course"])),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Image.asset(AppAssets.school, width: 20, height: 20),
                        const SizedBox(width: 6),
                        Expanded(child: Text(doc["school"])),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: Image.asset(AppAssets.download, width: 20, height: 20),
                          label: const Text("Tải về"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondaryTeal,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () =>
                              context.read<DocsBloc>().add(ToggleSave()),
                          icon: Image.asset(
                            state.isSaved ? AppAssets.saved : AppAssets.unsaved,
                            width: 20,
                            height: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Container(
                      height: 250,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      child: const Center(child: Text("PDF Preview nhỏ ở đây")),
                    ),
                  ],
                ),
              );
            } else if (state is DocsError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}