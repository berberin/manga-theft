import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:justice_mango/app/modules/home/tab/recent/recent_provider.dart';
import 'package:justice_mango/app/theme/color_theme.dart';

import 'widget/recent_card.dart';

class RecentTab extends ConsumerWidget {
  const RecentTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentStateProvider = ref.watch(recentProvider);
    return Scaffold(
      backgroundColor: nearlyWhite,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 32,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'recentManga'.tr(),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      letterSpacing: 0.27,
                    ),
              ),
            ),
            recentStateProvider.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: Text(
                        'noRecentManga'.tr(),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  )
                : Column(
                    //verticalDirection: VerticalDirection.up,
                    children: List.generate(
                      recentStateProvider.length,
                      (index) => RecentCard(
                        recentArgs: recentStateProvider[index],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
