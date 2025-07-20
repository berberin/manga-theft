import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:manga_theft/app/base/base_stateless_widget.dart';
import 'package:manga_theft/app/modules/home/cubit/recent/recent_cubit.dart';
import 'package:manga_theft/app/modules/home/cubit/recent/recent_state.dart';
import 'package:manga_theft/app/theme/color_theme.dart';

import 'widget/recent_card.dart';

class RecentTab extends BaseStatelessWidget<RecentCubit, RecentState> {
  const RecentTab({super.key});

  @override
  void onCubitReady(RecentCubit cubit) {
    cubit.init();
    super.onCubitReady(cubit);
  }

  @override
  Widget buildContent(BuildContext context, RecentCubit cubit, RecentState state) {
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
            state.recentArgs.isEmpty
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
                      state.recentArgs.length,
                      (index) => RecentCard(
                        recentArgs: state.recentArgs[index],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
