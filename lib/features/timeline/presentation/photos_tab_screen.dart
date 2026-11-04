import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/timeline/timeline_controller.dart';
import '../../../core/widgets/common.dart';
import 'timeline_view.dart';

class PhotosTabScreen extends ConsumerWidget {
  const PhotosTabScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeline = ref.watch(timelineProvider);
    final state = timeline.value;
    return ColoredBox(
      color: AppColors.background,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const ColoredBox(
              color: Colors.white,
              child: SizedBox(width: double.infinity, child: AppHeader()),
            ),
            Expanded(
              child: state != null
                  ? TimelineView(state: state)
                  : timeline.hasError
                  ? ErrorView(
                      error: timeline.error!,
                      onRetry: ref.read(timelineProvider.notifier).refresh,
                    )
                  : const Center(child: CircularProgressIndicator()),
            ),
          ],
        ),
      ),
    );
  }
}
